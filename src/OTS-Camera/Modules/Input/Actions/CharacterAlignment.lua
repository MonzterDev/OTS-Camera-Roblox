return function(singleton)
	local actionNames = singleton.Utilities.Enums.InputActionNames

	return {
		[actionNames.AlignCharacter] = function(actionName, inputState, inputObject)
			singleton:AlignCharacter()
		end,
		[actionNames.UnalignCharacter] = function(actionName, inputState, inputObject)
			singleton:UnalignCharacter()
		end,
		[actionNames.SwitchCharacterAlignment] = function(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.End then
				return
			end
			if singleton.IsCharacterAligned then
				singleton:UnalignCharacter()
			else
				singleton:AlignCharacter()
			end
		end,
		[actionNames.HoldUnalignCharacter] = function(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.Begin then
				singleton:UnalignCharacter()
			elseif inputState == Enum.UserInputState.End then
				singleton:AlignCharacter()
			end
		end,
	}
end
