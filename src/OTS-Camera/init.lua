local OTS_Cam = {}

--// SERVICES //--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--// CONSTANTS //--
local PLAYER = Players.LocalPlayer

local SHOULDER_DIRECTION = {RIGHT = 1, LEFT = -1}
local VERTICAL_ANGLE_LIMITS = NumberRange.new(-45, 45)

local IS_ON_DESKTOP = UserInputService.MouseEnabled

--// MODULES //--
local Input = require(script.Input)

--// VARIABLES //--
local Character = PLAYER.Character or PLAYER.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

--// CONFIG //--
OTS_Cam.CameraSettings = {
    Default = {
        Field_Of_View = 70,
        Offset = Vector3.new(2.5, 2.5, 8),
        Mouse_Sensitivity_X = 3,
        Mouse_Sensitivity_Y = 3,
        Touch_Sensitivity_X = 3,
        Touch_Sensitivity_Y = 3,
        Gamepad_Sensitivity_X = 10,
        Gamepad_Sensitivity_Y = 10,
        Lerp_Speed = 0.5,
		Align_Character = true,
		Lock_Mouse = true,
		Shoulder_Direction = SHOULDER_DIRECTION.RIGHT
    },

    Zoomed = {
		Field_Of_View = 40,
        Offset = Vector3.new(1.5, 1.5, 6),
        Mouse_Sensitivity_X = 1.5,
        Mouse_Sensitivity_Y = 1.5,
        Touch_Sensitivity_X = 1.5,
        Touch_Sensitivity_Y = 1.5,
        Gamepad_Sensitivity_X = 5,
        Gamepad_Sensitivity_Y = 5,
        Lerp_Speed = 0.5,
		Align_Character = true,
		Lock_Mouse = true,
		Shoulder_Direction = SHOULDER_DIRECTION.RIGHT
    }
}

--// PROPERTIES //--
local SavedCameraSettings: table
local SavedMouseBehavior: Enum.MouseBehavior

local CameraWasEnabled: boolean
local CameraMode: string

OTS_Cam.HorizontalAngle = 0
OTS_Cam.VerticalAngle = 0
OTS_Cam.ShoulderDirection = 1

OTS_Cam.IsCharacterAligned = false
OTS_Cam.IsMouseLocked = false
OTS_Cam.IsEnabled = false



--// FUNCTIONS //--

local function Lerp(x, y, a)
	return x + (y - x) * a
end


-- Saves the current Camera's settings
-- Called before enabling the OTS Camera
local function saveDefaultCamera()
	local currentCamera = workspace.CurrentCamera
	SavedCameraSettings = {
		FieldOfView = currentCamera.FieldOfView,
		CameraSubject = currentCamera.CameraSubject,
		CameraType = currentCamera.CameraType
	}
	SavedMouseBehavior = UserInputService.MouseBehavior
end
--

-- Resets Player's Camera settings to original settings before Enabling
local function loadDefaultCamera()
	local currentCamera = workspace.CurrentCamera
	for setting, value in pairs(SavedCameraSettings) do
		currentCamera[setting] = value
	end
end

-- Returns Delta based on Input method
local function getDelta()
	local delta = Input.GetDelta()

	local xSensitivity, ySensitivity
	if UserInputService.GamepadEnabled then
		xSensitivity = OTS_Cam.CameraSettings[CameraMode].Gamepad_Sensitivity_X
		ySensitivity = OTS_Cam.CameraSettings[CameraMode].Gamepad_Sensitivity_Y
	elseif UserInputService.TouchEnabled then
		xSensitivity = OTS_Cam.CameraSettings[CameraMode].Touch_Sensitivity_X
		ySensitivity = OTS_Cam.CameraSettings[CameraMode].Touch_Sensitivity_Y
	else
		xSensitivity = OTS_Cam.CameraSettings[CameraMode].Mouse_Sensitivity_X
		ySensitivity = OTS_Cam.CameraSettings[CameraMode].Mouse_Sensitivity_Y
	end

	return Vector2.new(delta.X * xSensitivity, delta.Y * ySensitivity)
end
--

local function configureStateForEnabled()
	saveDefaultCamera()
	CameraMode = "Default"
	OTS_Cam.SetCharacterAlignment(OTS_Cam.CameraSettings[CameraMode].Align_Character)
	OTS_Cam.LockMouse(OTS_Cam.CameraSettings[CameraMode].Lock_Mouse)
	OTS_Cam.ShoulderDirection = OTS_Cam.CameraSettings[CameraMode].Shoulder_Direction

	--// Calculate angles //--
	local cameraCFrame = workspace.CurrentCamera.CFrame
	local x, y, z = cameraCFrame:ToOrientation()
	local horizontalAngle = y
	local verticalAngle = x
	----

	OTS_Cam.HorizontalAngle = horizontalAngle
	OTS_Cam.VerticalAngle = verticalAngle
end

local function configureStateForDisabled()
	OTS_Cam.SetCharacterAlignment(false)
	loadDefaultCamera()
	UserInputService.MouseBehavior = SavedMouseBehavior
	OTS_Cam.HorizontalAngle = 0
	OTS_Cam.VerticalAngle = 0
end


--
-- Main function which modifies the Camera
local function updateCamera()
	local currentCamera = workspace.CurrentCamera
	local activeCameraSettings = OTS_Cam.CameraSettings[CameraMode]

	currentCamera.CameraType = Enum.CameraType.Scriptable

	--// Moves camera based on Input //--
	local inputDelta = getDelta()
	OTS_Cam.HorizontalAngle -= inputDelta.X/currentCamera.ViewportSize.X
	OTS_Cam.VerticalAngle -= inputDelta.Y/currentCamera.ViewportSize.Y
	OTS_Cam.VerticalAngle = math.rad(math.clamp(math.deg(OTS_Cam.VerticalAngle), VERTICAL_ANGLE_LIMITS.Min, VERTICAL_ANGLE_LIMITS.Max))
	----

	local humanoidRootPart = Character ~= nil and Character:FindFirstChild("HumanoidRootPart")
	if humanoidRootPart ~= nil then -- Disable if Player dies

		currentCamera.FieldOfView = Lerp(
			currentCamera.FieldOfView,
			activeCameraSettings.Field_Of_View,
			activeCameraSettings.Lerp_Speed
		)

		--// Address shoulder direction //--
		local offset = activeCameraSettings.Offset
		offset = Vector3.new(offset.X * OTS_Cam.ShoulderDirection, offset.Y, offset.Z)
		----

		--// Calculate new camera cframe //--
		local newCameraCFrame = CFrame.new(humanoidRootPart.Position) *
			CFrame.Angles(0, OTS_Cam.HorizontalAngle, 0) *
			CFrame.Angles(OTS_Cam.VerticalAngle, 0, 0) *
			CFrame.new(offset)

		newCameraCFrame = currentCamera.CFrame:Lerp(newCameraCFrame, activeCameraSettings.Lerp_Speed)
		----

		--// Raycast for obstructions //--
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {Character}
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		local raycastResult = workspace:Raycast(
			humanoidRootPart.Position,
			newCameraCFrame.p - humanoidRootPart.Position,
			raycastParams
		)
		----

		--// Address obstructions if any //--
		if raycastResult ~= nil then
			local obstructionDisplacement = (raycastResult.Position - humanoidRootPart.Position)
			local obstructionPosition = humanoidRootPart.Position + (obstructionDisplacement.Unit * (obstructionDisplacement.Magnitude - 0.1))
			local x,y,z,r00,r01,r02,r10,r11,r12,r20,r21,r22 = newCameraCFrame:GetComponents()
			newCameraCFrame = CFrame.new(obstructionPosition.x, obstructionPosition.y, obstructionPosition.z, r00, r01, r02, r10, r11, r12, r20, r21, r22)
		end
		----

		--// Address character alignment //--
		if activeCameraSettings.Align_Character == true then
			local newHumanoidRootPartCFrame = CFrame.new(humanoidRootPart.Position) *
				CFrame.Angles(0, OTS_Cam.HorizontalAngle, 0)
			humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(newHumanoidRootPartCFrame, activeCameraSettings.Lerp_Speed/2)
		end
		----

		currentCamera.CFrame = newCameraCFrame
	else
		OTS_Cam.Disable()
		CameraWasEnabled = true
	end
end
----

--// METHODS //--

function OTS_Cam.SetCharacterAlignment(aligned: boolean)
	Humanoid.AutoRotate = not aligned
	OTS_Cam.IsCharacterAligned = aligned
end

function OTS_Cam.LockMouse(lock: boolean)
	OTS_Cam.IsMouseLocked = lock
	if lock == true then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end

function OTS_Cam.Enable()
	OTS_Cam.IsEnabled = true
	CameraWasEnabled = true
	configureStateForEnabled()

	RunService:BindToRenderStep(
		"OTS_CAMERA",
		Enum.RenderPriority.Camera.Value - 10,
		function()
			if OTS_Cam.IsEnabled == true then
				updateCamera()
			end
		end
	)
end

function OTS_Cam.Disable()
	configureStateForDisabled()
	OTS_Cam.IsEnabled = false
	CameraWasEnabled = false
	RunService:UnbindFromRenderStep("OTS_CAMERA")
end
----


--// CONTROLS //--

if IS_ON_DESKTOP then
	UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
		if gameProcessedEvent == false and OTS_Cam.IsEnabled == true then
			if inputObject.KeyCode == Enum.KeyCode.Q then
				OTS_Cam.ShoulderDirection = SHOULDER_DIRECTION.LEFT
			elseif inputObject.KeyCode == Enum.KeyCode.E then
				OTS_Cam.ShoulderDirection = SHOULDER_DIRECTION.RIGHT
			end
			if inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
				CameraMode = "Zoomed"
			end

			if inputObject.KeyCode == Enum.KeyCode.LeftControl then
				if OTS_Cam.IsEnabled == true then
					OTS_Cam.LockMouse(not OTS_Cam.IsMouseLocked)
				end
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(inputObject, gameProcessedEvent)
		if gameProcessedEvent == false and OTS_Cam.IsEnabled == true then
			if inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
				CameraMode = "Default"
			end
		end
	end)
end

PLAYER.CharacterAdded:Connect(function(character)
	Character = character
	Humanoid = character:WaitForChild("Humanoid")

	if CameraWasEnabled then
		OTS_Cam.Enable()
	end
end)

return OTS_Cam
