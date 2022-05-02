local CameraSystem = {}

--// STATIC PROPERTIES //--

CameraSystem.ClassName = "OTS Camera System"

CameraSystem.InitializeObject = nil
CameraSystem.StartObject = nil

--// CONSTRUCTOR //--

function CameraSystem.new()
	local self = setmetatable({}, CameraSystem)

	--// INSTANCE PROPERTIES //--

	--////--

	CameraSystem.InitializeObject(self)
	CameraSystem.StartObject(self)

	return self
end

--// STATIC METHODS //--

--// INSTANCE METHODS //--

--// INSTRUCTIONS //--

CameraSystem.__index = CameraSystem

local ConfigurationsFolder = script:WaitForChild("Configurations")
local ModulesFolder = script:WaitForChild("Modules")
local UtilitiesFolder = script:WaitForChild("Utilities")
local Folders = { Configurations = ConfigurationsFolder, Modules = ModulesFolder, Utilities = UtilitiesFolder }
require(UtilitiesFolder:WaitForChild("Loader")).Load(CameraSystem, Folders)

local singleton = CameraSystem.new()

return singleton
