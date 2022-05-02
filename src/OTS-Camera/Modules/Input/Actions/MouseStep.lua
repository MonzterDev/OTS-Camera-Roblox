return function(singleton)
	local actionNames = singleton.Utilities.Enums.InputActionNames

	return {
		[actionNames.StepMouseIn] = function(actionName, inputState, inputObject)
			singleton:StepMouseIn()
		end,
		[actionNames.StepMouseOut] = function(actionName, inputState, inputObject)
			singleton:StepMouseOut()
		end,
		[actionNames.SwitchMouseStep] = function(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.End then
				return
			end
			if singleton.IsMouseSteppedIn then
				singleton:StepMouseOut()
			else
				singleton:StepMouseIn()
			end
		end,
		[actionNames.HoldMouseStepOut] = function(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.Begin then
				singleton:StepMouseOut()
			elseif inputState == Enum.UserInputState.End then
				singleton:StepMouseIn()
			end
		end,
	}
end
