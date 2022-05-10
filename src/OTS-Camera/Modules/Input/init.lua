local Input = {}

--// CONSTANTS //--

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local GenerateTouchControls = require(script.TouchControls)

local GenerateShoulderAlignmentActions = require(script.Actions.ShoulderAlignment)
local GenerateMouseStepActions = require(script.Actions.MouseStep)
local GenerateCharacterAlignmentActions = require(script.Actions.CharacterAlignment)
local GenerateCameraSettingsActions = require(script.Actions.CameraSettings)

--// VARIABLES //--

local GAMEPAD_DEAD	= 0.15
local x, y = 0, 0

--// INITIALIZER //--

function Input:Initialize()
	self.TouchControls = GenerateTouchControls(self)

	self.Hotkeys = self.Utilities.Miscellaneous.DeepCopyTable(self.Configurations.Input)

	self.InputActions = self.Utilities.Miscellaneous.MergeTables(
		GenerateShoulderAlignmentActions(self),
		GenerateMouseStepActions(self),
		GenerateCharacterAlignmentActions(self),
		GenerateCameraSettingsActions(self)
	)

	self.HotkeyChanged = self.Utilities.Signal.new()
	self.MobileButtonEnabled = self.Utilities.Signal.new()
	self.MobileButtonDisabled = self.Utilities.Signal.new()
end

function Input:Start()
	self.Enabled:Connect(function()
		self.TouchControls.Enable()

		for _, actionName in pairs(self.Utilities.Enums.InputActionNames) do
			self:BindAction(actionName)
		end
	end)

	self.Disabled:Connect(function()
		self.TouchControls.Disable()

		for _, actionName in pairs(self.Utilities.Enums.InputActionNames) do
			self:UnbindAction(actionName)
		end
	end)
end

--// METHODS //--

function Input:UpdateAngles()
	local inputDelta = self:CaptureInput()
	print(inputDelta)
	local currentCamera = workspace.CurrentCamera

	self.HorizontalAngle -= inputDelta.X / currentCamera.ViewportSize.X
	self.VerticalAngle -= inputDelta.Y / currentCamera.ViewportSize.Y
	self.VerticalAngle = math.rad(
		math.clamp(
			math.deg(self.VerticalAngle),
			self.ActiveCameraSettings.VerticalAngleLimits.Min,
			self.ActiveCameraSettings.VerticalAngleLimits.Max
		)
	)
end

function Input:CaptureInput()
	if UserInputService.GamepadEnabled then
		return Vector2.new(x, y)
	elseif UserInputService.TouchEnabled then
		return self.TouchControls:GetDelta() * self.ActiveCameraSettings.TouchSensitivity
	else
		return UserInputService:GetMouseDelta() * self.ActiveCameraSettings.MouseSensitivity
	end
end

function Input:BindAction(actionName)
	local hotkey = self.Hotkeys[actionName]
	local mobileButton = self.Hotkeys.MobileButtons[actionName]
	mobileButton = mobileButton ~= nil and mobileButton or false
	if hotkey or mobileButton then
		ContextActionService:BindAction(
			actionName,
			self.InputActions[actionName],
			mobileButton,
			hotkey or Enum.UserInputType.None
		)
	end
end

function Input:UnbindAction(actionName)
	ContextActionService:UnbindAction(actionName)
end

function Input:SetHotkey(actionName, hotkey)
	if not self.IsEnabled then
		warn("OTS Camera System Logic Warning: Attempt to change hotkey while the OTS Camera System is disabled")
	end
	assert(actionName ~= nil, "OTS Camera System Argument Error: Argument 1 nil or missing")
	assert(
		typeof(actionName) == "string",
		"OTS Camera System Argument Error: string expected, got " .. typeof(actionName)
	)
	assert(
		self.Utilities.Miscellaneous.IsValueInTable(actionName, self.Utilities.Enums.InputActionNames),
		"OTS Camera System Argument Error: Attempt to set hotkey to unrecognized input action " .. actionName
	)

	local oldHotkey = self.Hotkeys[actionName]
	if oldHotkey == nil then
		warn(
			"OTS Camera System Logic Warning: Attempt to set hotkey to "
				.. actionName
				.. " which is already bound to "
				.. tostring(oldHotkey)
		)
	end

	self.Hotkeys[actionName] = hotkey
	if self.IsEnabled then
		self:UnbindAction(actionName)
		self:BindAction(actionName)
	end

	self.HotkeyChanged:Fire(actionName, hotkey)
end

function Input:EnableMobileButton(actionName)
	if not self.IsEnabled then
		warn("OTS Camera System Logic Warning: Attempt to change hotkey while the OTS Camera System is disabled")
	end
	assert(actionName ~= nil, "OTS Camera System Argument Error: Argument 1 nil or missing")
	assert(
		typeof(actionName) == "string",
		"OTS Camera System Argument Error: string expected, got " .. typeof(actionName)
	)
	assert(
		self.Utilities.Miscellaneous.IsValueInTable(actionName, self.Utilities.Enums.InputActionNames),
		"OTS Camera System Argument Error: Attempt to set hotkey to unrecognized input action " .. actionName
	)
	local mobileButton = self.Hotkeys.MobileButtons[actionName]
	if mobileButton == nil then
		self.Hotkeys.MobileButtons[actionName] = false
		mobileButton = false
	end

	if mobileButton then
		warn("OTS Camera System Logic Warning: Attempt to enable an already enabled mobile button")
	else
		self.Hotkeys.MobileButtons[actionName] = true
	end

	if self.IsEnabled then
		self:UnbindAction(actionName)
		self:BindAction(actionName)
	end

	self.MobileButtonEnabled:Fire(actionName)
end

function Input:DisableMobileButton(actionName)
	if not self.IsEnabled then
		warn("OTS Camera System Logic Warning: Attempt to change hotkey while the OTS Camera System is disabled")
	end
	assert(actionName ~= nil, "OTS Camera System Argument Error: Argument 1 nil or missing")
	assert(
		typeof(actionName) == "string",
		"OTS Camera System Argument Error: string expected, got " .. typeof(actionName)
	)
	assert(
		self.Utilities.Miscellaneous.IsValueInTable(actionName, self.Utilities.Enums.InputActionNames),
		"OTS Camera System Argument Error: Attempt to set hotkey to unrecognized input action " .. actionName
	)
	local mobileButton = self.Hotkeys.MobileButtons[actionName]
	if mobileButton == nil then
		self.Hotkeys.MobileButtons[actionName] = false
		mobileButton = false
	end

	if not mobileButton then
		warn("OTS Camera System Logic Warning: Attempt to enable an already enabled mobile button")
	else
		self.Hotkeys.MobileButtons[actionName] = false
	end

	if self.IsEnabled then
		self:UnbindAction(actionName)
		self:BindAction(actionName)
	end

	self.MobileButtonDisabled:Fire(actionName)
end

local X_SPEED, Y_SPEED = 100, 15
local MIN_Y, MAX_Y	= -1.4, 1.4
UserInputService.InputChanged:Connect(function(inputObject, processed)
	if not processed then
		if inputObject.KeyCode == Enum.KeyCode.Thumbstick2 then
			local input	= inputObject.Position
			if input.Magnitude > GAMEPAD_DEAD then
				x	= (input.X * X_SPEED)
				y	= -(input.Y * Y_SPEED)
			else
				x = 0
				y = 0
			end
		end
	end
end)

return Input
