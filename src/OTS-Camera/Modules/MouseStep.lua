local MouseStep = {}

--// CONSTANTS //--

local USER_INPUT_SERVICE = game:GetService("UserInputService")

--// VARIABLES //--

--// INITIALIZER //--

function MouseStep:Initialize()
	self.IsMouseSteppedIn = false
	self.MouseSteppedIn = self.Utilities.Signal.new()
	self.MouseSteppedOut = self.Utilities.Signal.new()
end

--// METHODS //--

function MouseStep:StepMouseIn()
	if not self.IsEnabled then
		warn("OTS Camera System Logic Warning: Attempt to step mouse in while the OTS Camera System is disabled")
	end

	self.IsMouseSteppedIn = true
	self.MouseSteppedIn:Fire()
end

function MouseStep:StepMouseOut()
	if not self.IsEnabled then
		warn("OTS Camera System Logic Warning: Attempt to step mouse in while the OTS Camera System is disabled")
	end

	self.IsMouseSteppedIn = false
	self.MouseSteppedOut:Fire()
end

function MouseStep:UpdateMouseStep()
	if self.IsMouseSteppedIn then
		USER_INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.LockCenter
	else
		USER_INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.Default
	end
end

return MouseStep
