local UserInputService = game:GetService("UserInputService")

return function(singleton)
	local touchDelta = Vector2.new()
	local selectedTouchInputs = {}
	local touchStartedConnection, touchMovedConnection, touchEndedConnection

	return {
		Enable = function()
			touchStartedConnection = UserInputService.TouchStarted:Connect(function(inputObject, gameProcessedEvent)
				if not gameProcessedEvent then
					local position = inputObject.Position
					position = Vector2.new(position.X, position.Y)
					if not singleton.Utilities.Miscellaneous.IsInDynamicThumbstickArea(position) then
						selectedTouchInputs[inputObject] = true
					end
				end
			end)
			touchMovedConnection = UserInputService.TouchMoved:Connect(function(inputObject, gameProcessedEvent)
				if selectedTouchInputs[inputObject] then
					local delta = inputObject.Delta
					touchDelta = Vector2.new(delta.X, delta.Y)
				end
			end)
			touchEndedConnection = UserInputService.TouchEnded:Connect(function(inputObject, gameProcessedEvent)
				if selectedTouchInputs[inputObject] then
					selectedTouchInputs[inputObject] = nil
				end
			end)
		end,
		Disable = function()
			touchStartedConnection:Disconnect()
			touchMovedConnection:Disconnect()
			touchEndedConnection:Disconnect()
		end,
		GetDelta = function()
			local temp = touchDelta
			touchDelta = Vector2.new(0, 0)
			return temp
		end,
	}
end
