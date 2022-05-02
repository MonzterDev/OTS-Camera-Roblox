return function(singleton)
	local actionNames = singleton.Utilities.Enums.InputActionNames

	return {
		[actionNames.AlignRightShoulder] = function(actionName, inputState, inputObject)
			singleton:AlignRightShoulder()
		end,
		[actionNames.AlignLeftShoulder] = function(actionName, inputState, inputObject)
			singleton:AlignLeftShoulder()
		end,
		[actionNames.SwitchShoulderAlignment] = function(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.End then
				return
			end
			if singleton.ShoulderAlignment == singleton.Utilities.Enums.Shoulders.Right then
				singleton:AlignLeftShoulder()
			else
				singleton:AlignRightShoulder()
			end
		end,
	}
end
