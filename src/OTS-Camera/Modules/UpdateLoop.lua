local UpdateLoop = {}

--// CONSTANTS //--

local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = PlayerService.LocalPlayer

--// VARIABLES //--

--// INITIALIZER //--

function UpdateLoop:Initialize()
	self.UpdateUniqueKey = "OTS_CAMERA_SYSTEM_UPDATE"

	self.HorizontalAngle = 0
	self.VerticalAngle = 0
end

--// METHODS //--

function UpdateLoop:StartUpdateLoop()
	RunService:BindToRenderStep(self.UpdateUniqueKey, Enum.RenderPriority.Camera.Value - 10, function()
		self:UpdateFunction()
	end)
end

function UpdateLoop:StopUpdateLoop()
	RunService:UnbindFromRenderStep(self.UpdateUniqueKey)
end

function UpdateLoop:SetCameraRotationFromCFrame(cframe)
	if not self.IsEnabled then
		warn("OTS Camera System Logic Warning: Attempt to change hotkey while the OTS Camera System is disabled")
	end
	assert(cframe ~= nil, "OTS Camera System Argument Error: Argument 1 nil or missing")
	assert(typeof(cframe) == "CFrame", "OTS Camera System Argument Error: CFrame expected, got " .. typeof(cframe))

	self.HorizontalAngle, self.VerticalAngle = self.Utilities.Miscellaneous.GetHorizontalAndVerticalAnglesFromCFrame(
		cframe
	)
end

function UpdateLoop:UpdateFunction()
	self:UpdateMouseStep()
	self:UpdateCharacterAlignment()
	self:UpdateCameraSettings()
	self:UpdateAngles()

	local currentCamera = workspace.CurrentCamera
	local character = LocalPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart == nil then
		return
	end

	--// Lerp field of view //--
	currentCamera.FieldOfView = self.Utilities.Math.Lerp(
		currentCamera.FieldOfView,
		self.ActiveCameraSettings.FieldOfView,
		self.ActiveCameraSettings.LerpSpeed
	)
	----

	--// Address shoulder direction //--
	local offset = self.ActiveCameraSettings.Offset
	offset = Vector3.new(offset.X * (self.ShoulderAlignment:lower() == "right" and 1 or -1), offset.Y, offset.Z)
	----

	--// Calculate new camera cframe //--
	local newCameraCFrame = CFrame.new(humanoidRootPart.Position)
		* CFrame.Angles(0, self.HorizontalAngle, 0)
		* CFrame.Angles(self.VerticalAngle, 0, 0)
		* CFrame.new(offset)

	newCameraCFrame = currentCamera.CFrame:Lerp(newCameraCFrame, self.ActiveCameraSettings.LerpSpeed)
	----

	--// Raycast for obstructions //--
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = { character }
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	local raycastResult = workspace:Raycast(
		humanoidRootPart.Position,
		newCameraCFrame.Position - humanoidRootPart.Position,
		raycastParams
	)
	----

	--// Address obstructions if any //--
	if raycastResult ~= nil then
		local obstructionDisplacement = (raycastResult.Position - humanoidRootPart.Position)
		local obstructionPosition = humanoidRootPart.Position
			+ (obstructionDisplacement.Unit * (obstructionDisplacement.Magnitude - 0.1))
		local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = newCameraCFrame:GetComponents()
		newCameraCFrame = CFrame.new(
			obstructionPosition.x,
			obstructionPosition.y,
			obstructionPosition.z,
			r00,
			r01,
			r02,
			r10,
			r11,
			r12,
			r20,
			r21,
			r22
		)
	end
	----

	--// Address character alignment //--
	if self.IsCharacterAligned then
		local newHumanoidRootPartCFrame = CFrame.new(humanoidRootPart.Position)
			* CFrame.Angles(0, self.HorizontalAngle, 0)
		humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(
			newHumanoidRootPartCFrame,
			self.ActiveCameraSettings.LerpSpeed / 2
		)
	end
	----

	currentCamera.CFrame = newCameraCFrame
end

return UpdateLoop
