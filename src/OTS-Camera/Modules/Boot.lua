local Boot = {}

--// CONSTANTS //--

local USER_INPUT_SERVICE = game:GetService("UserInputService")

--// VARIABLES //--

--// INITIALIZER //--

function Boot:Initialize()
	self.IsEnabled = false
	self.Enabled = self.Utilities.Signal.new()
	self.Disabled = self.Utilities.Signal.new()
	self.SavedCameraState = nil
end

--// METHODS //--

function Boot:Enable()
	assert(
		not self.IsEnabled,
		"OTS Camera System Logic Error: Attempt to enable OTS Camera System while already enabled"
	)

	self.IsEnabled = true
	self.Enabled:Fire()
	self:ConfigureStateForEnabled()
	self:StartUpdateLoop()
end

function Boot:Disable()
	assert(self.IsEnabled, "OTS Camera System Logic Error: Attempt to disable OTS Camera System while already disabled")

	self.IsEnabled = false
	self.Disabled:Fire()
	self:ConfigureStateForDisabled()
	self:StopUpdateLoop()
end

function Boot:ConfigureStateForEnabled()
	self:SaveCameraState()
	self:SetActiveCameraSettings(self.Configurations.Defaults.ActiveCameraSettingsIdentifier)
	if self.Configurations.Defaults.ShoulderAlignment == self.Utilities.Enums.Shoulders.Right then
		self:AlignRightShoulder()
	else
		self:AlignLeftShoulder()
	end
	if self.Configurations.Defaults.IsCharacterAligned then
		self:AlignCharacter()
	else
		self:UnalignCharacter()
	end
	if self.Configurations.Defaults.IsMouseSteppedIn then
		self:StepMouseIn()
	else
		self:StepMouseOut()
	end
	self.HorizontalAngle, self.VerticalAngle =
		self.Utilities.Miscellaneous.GetHorizontalAndVerticalAnglesFromCameraCFrame()
end

function Boot:ConfigureStateForDisabled()
	self:LoadCameraState()
end

function Boot:SaveCameraState()
	local currentCamera = workspace.CurrentCamera

	local humanoid = self.Utilities.Miscellaneous.GetLocalHumanoid()
	local autoRotate
	if humanoid then
		autoRotate = humanoid.AutoRotate
	end

	self.SavedCameraState = {
		FieldOfView = currentCamera.FieldOfView,
		CameraSubject = currentCamera.CameraSubject,
		CameraType = currentCamera.CameraType,
		MouseBehavior = USER_INPUT_SERVICE.MouseBehavior,
		AutoRotate = autoRotate,
	}
end

function Boot:LoadCameraState()
	local currentCamera = workspace.CurrentCamera
	local savedCameraState = self.SavedCameraState

	currentCamera.FieldOfView = savedCameraState.FieldOfView
	currentCamera.CameraSubject = savedCameraState.CameraSubject
	currentCamera.CameraType = savedCameraState.CameraType
	USER_INPUT_SERVICE.MouseBehavior = savedCameraState.MouseBehavior

	if savedCameraState.AutoRotate then
		local humanoid = self.Utilities.Miscellaneous.GetLocalHumanoid()
		if humanoid then
			humanoid.AutoRotate = savedCameraState.AutoRotate
		end
	end
end

return Boot
