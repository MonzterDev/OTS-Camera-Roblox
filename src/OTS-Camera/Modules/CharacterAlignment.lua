local CharacterAlignment = {}

--// CONSTANTS //--

--// VARIABLES //--

--// INITIALIZER //--

function CharacterAlignment:Initialize()
	self.IsCharacterAligned = false
	self.CharacterAligned = self.Utilities.Signal.new()
	self.CharacterUnaligned = self.Utilities.Signal.new()
end

--// METHODS //--

function CharacterAlignment:AlignCharacter()
	if not self.IsEnabled then
		warn(
			"OTS Camera System Logic Warning: Attempt to enable character alignment while the OTS Camera System is disabled"
		)
	end

	self.IsCharacterAligned = true
	self.CharacterAligned:Fire()
end

function CharacterAlignment:UnalignCharacter()
	if not self.IsEnabled then
		warn(
			"OTS Camera System Logic Warning: Attempt to disable character alignment while the OTS Camera System is disabled"
		)
	end

	self.IsCharacterAligned = false
	self.CharacterUnaligned:Fire()
end

function CharacterAlignment:UpdateCharacterAlignment()
	local humanoid = self.Utilities.Miscellaneous.GetLocalHumanoid()

	if humanoid then
		humanoid.AutoRotate = false
	end
end

return CharacterAlignment
