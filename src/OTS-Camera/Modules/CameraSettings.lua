local CameraSettings = {}

--// CONSTANTS //--

--// VARIABLES //--

--// INITIALIZER //--

function CameraSettings:Initialize()
	self.ActiveCameraSettingsIdentifier = self.Configurations.Defaults.ActiveCameraSettingsIdentifier
	self.ActiveCameraSettings = nil
	self.ActiveCameraSettingsChanged = self.Utilities.Signal.new()
end

--// METHODS //--

function CameraSettings:SetActiveCameraSettings(cameraSettingsIdentifier)
	assert(cameraSettingsIdentifier ~= nil, "OTS Camera System Argument Error: Argument 1 nil or missing")
	assert(
		typeof(cameraSettingsIdentifier) == "string",
		"OTS Camera System Argument Error: string expected, got " .. typeof(cameraSettingsIdentifier)
	)
	local activeCameraSettingsIdentifier, activeCameraSettings = self.Utilities.Miscellaneous.IgnoreCaseIndex(
		self.Configurations.CameraSettings,
		cameraSettingsIdentifier
	)
	assert(
		activeCameraSettingsIdentifier ~= nil,
		"OTS Camera System Argument Error: Attempt to set unrecognized camera settings " .. cameraSettingsIdentifier
	)

	self.ActiveCameraSettingsIdentifier = activeCameraSettingsIdentifier
	self.ActiveCameraSettings = activeCameraSettings
	self.ActiveCameraSettingsChanged:Fire(activeCameraSettingsIdentifier, activeCameraSettings)
end

function CameraSettings:UpdateCameraSettings()
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
end

return CameraSettings
