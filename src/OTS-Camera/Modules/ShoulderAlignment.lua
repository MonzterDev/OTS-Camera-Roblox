local ShoulderAlignment = {}

--// CONSTANTS //--

--// VARIABLES //--

--// INITIALIZER //--

function ShoulderAlignment:Initialize()
	self.ShoulderAlignment = self.Utilities.Enums.Shoulders.Right
	self.RightShoulderAligned = self.Utilities.Signal.new()
	self.LeftShoulderAligned = self.Utilities.Signal.new()
end

--// METHODS //--

function ShoulderAlignment:AlignRightShoulder()
	if not self.IsEnabled then
		warn(
			"OTS Camera System Logic Warning: Attempt to change shoulder alignment while the OTS Camera System is disabled"
		)
	end

	self.ShoulderAlignment = self.Utilities.Enums.Shoulders.Right
	self.RightShoulderAligned:Fire()
end

function ShoulderAlignment:AlignLeftShoulder()
	if not self.IsEnabled then
		warn(
			"OTS Camera System Logic Warning: Attempt to change shoulder alignment while the OTS Camera System is disabled"
		)
	end

	self.ShoulderAlignment = self.Utilities.Enums.Shoulders.Left
	self.LeftShoulderAligned:Fire()
end

return ShoulderAlignment
