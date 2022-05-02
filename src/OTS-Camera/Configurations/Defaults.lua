return {
	IsCharacterAligned = true,
	IsMouseSteppedIn = true,
	ShoulderAlignment = "Right",
	ActiveCameraSettingsIdentifier = "DefaultShoulder",
	FilterNonCanCollideBaseParts = true,
	FilterTransparencyBaseParts = true,
	BasePartFilterTransparencyThreshold = 0.75,
	FilterTaggedBaseParts = { "Tag_A", "Tag_B" },
	IsUsingCustomBasePartFilterFunction = false,
	BasePartFilterFunction = function(basePart)
		return true
	end,
}
