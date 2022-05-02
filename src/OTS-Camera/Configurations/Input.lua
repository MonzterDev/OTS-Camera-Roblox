local InputActionNames = require(script.Parent.Parent.Utilities.Enums).InputActionNames

return {
	[InputActionNames.AlignRightShoulder] = Enum.KeyCode.E,
	[InputActionNames.AlignLeftShoulder] = Enum.KeyCode.Q,
	[InputActionNames.SwitchShoulderAlignment] = Enum.KeyCode.R,

	[InputActionNames.StepMouseIn] = nil,
	[InputActionNames.StepMouseOut] = nil,
	[InputActionNames.SwitchMouseStep] = Enum.KeyCode.LeftControl,
	[InputActionNames.HoldMouseStepOut] = nil,

	[InputActionNames.AlignCharacter] = nil,
	[InputActionNames.UnalignCharacter] = nil,
	[InputActionNames.SwitchCharacterAlignment] = nil,
	[InputActionNames.HoldUnalignCharacter] = Enum.KeyCode.C,

	[InputActionNames.ZoomCamera] = nil,
	[InputActionNames.UnzoomCamera] = nil,
	[InputActionNames.SwitchCameraZoom] = nil,
	[InputActionNames.HoldCameraZoom] = Enum.UserInputType.MouseButton2,

	MobileButtons = {
		[InputActionNames.SwitchShoulderAlignment] = false,
		[InputActionNames.SwitchCharacterAlignment] = true,
		[InputActionNames.SwitchCameraZoom] = true,
	},
}
