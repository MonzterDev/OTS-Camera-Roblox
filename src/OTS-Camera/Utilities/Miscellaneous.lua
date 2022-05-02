local Miscellaneous = {}

--// CONSTANTS //--

local PLAYERS_SERVICE = game:GetService("Players")

--// VARIABLES //--

--// FUNCTIONS //--

function Miscellaneous.GetHorizontalAndVerticalAnglesFromCFrame(cframe)
	local angleX, angleY = cframe:ToOrientation()
	return angleY, angleX
end

function Miscellaneous.GetHorizontalAndVerticalAnglesFromCameraCFrame()
	local currentCamera = workspace.CurrentCamera
	local cameraCFrame = currentCamera.CFrame
	return Miscellaneous.GetHorizontalAndVerticalAnglesFromCFrame(cameraCFrame)
end

function Miscellaneous.GetLocalHumanoid()
	local character = PLAYERS_SERVICE.LocalPlayer.Character
	if character then
		return character:FindFirstChild("Humanoid")
	end
end

function Miscellaneous.IgnoreCaseIndex(dictionary, key)
	for index, value in pairs(dictionary) do
		if index:lower() == key:lower() then
			return key, value
		end
	end
end

function Miscellaneous.IsInDynamicThumbstickArea(pos)
	local player = PLAYERS_SERVICE.LocalPlayer
	local playerGui = player:FindFirstChildOfClass("PlayerGui")
	local touchGui = playerGui and playerGui:FindFirstChild("TouchGui")
	local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
	local thumbstickFrame = touchFrame and touchFrame:FindFirstChild("DynamicThumbstickFrame")

	if not thumbstickFrame then
		return false
	end

	if not touchGui.Enabled then
		return false
	end

	local posTopLeft = thumbstickFrame.AbsolutePosition
	local posBottomRight = posTopLeft + thumbstickFrame.AbsoluteSize

	return pos.X >= posTopLeft.X and pos.Y >= posTopLeft.Y and pos.X <= posBottomRight.X and pos.Y <= posBottomRight.Y
end

function Miscellaneous.ShallowCopyTable(tableToCopy)
	local newTable = {}

	for index, value in pairs(tableToCopy) do
		newTable[index] = value
	end

	return newTable
end

function Miscellaneous.DeepCopyTable(tableToCopy)
	local newTable = {}

	for index, value in pairs(tableToCopy) do
		if typeof(value) == "table" then
			value = Miscellaneous.DeepCopyTable(value)
		end
		newTable[index] = value
	end

	return newTable
end

function Miscellaneous.MergeTables(...)
	local newTable = {}

	for _, toMergeTable in pairs({ ... }) do
		for index, value in pairs(toMergeTable) do
			newTable[index] = value
		end
	end

	return newTable
end

function Miscellaneous.IsValueInTable(targetValue, searchTable)
	for _, value in pairs(searchTable) do
		if value == targetValue then
			return true
		end
	end
	return false
end

return Miscellaneous
