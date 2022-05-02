return function(singleton)
	local actionNames = singleton.Utilities.Enums.InputActionNames

	return {
		[actionNames.ZoomCamera] = function(actionName, inputState, inputObject)
			singleton:SetActiveCameraSettings("ZoomedShoulder")
		end,
		[actionNames.UnzoomCamera] = function(actionName, inputState, inputObject)
			singleton:SetActiveCameraSettings("DefaultShoulder")
		end,
		[actionNames.SwitchCameraZoom] = function(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.End then
				return
			end
			if singleton.ActiveCameraSettingsIdentifier == "DefaultShoulder" then
				singleton:SetActiveCameraSettings("ZoomedShoulder")
			else
				singleton:SetActiveCameraSettings("DefaultShoulder")
			end
		end,
		[actionNames.HoldCameraZoom] = function(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.Begin then
				singleton:SetActiveCameraSettings("ZoomedShoulder")
			elseif inputState == Enum.UserInputState.End then
				singleton:SetActiveCameraSettings("DefaultShoulder")
			end
		end,
	}
end
