local Loader = {}

--// CONSTANTS //--

--// VARIABLES //--

--// FUNCTIONS //--

function Loader.Load(cameraSystemClass, folders)
	Loader.LoadConfigurations(cameraSystemClass, folders.Configurations:GetChildren())
	Loader.LoadUtilities(cameraSystemClass, folders.Utilities:GetChildren())
	Loader.LoadModules(cameraSystemClass, folders.Modules:GetChildren())
end

function Loader.LoadConfigurations(cameraSystemClass, configurations)
	cameraSystemClass.Configurations = {}
	for _, configuration in pairs(configurations) do
		cameraSystemClass.Configurations[configuration.Name] = require(configuration)
	end
end

function Loader.LoadModules(cameraSystemClass, modules)
	local initializeFunctions = {}
	local startFunctions = {}

	for _, module in pairs(modules) do
		module = require(module)
		if module.Initialize then
			table.insert(initializeFunctions, module.Initialize)
		end
		if module.Start then
			table.insert(startFunctions, module.Start)
		end
		for identifier, item in pairs(module) do
			if identifier ~= "Initialize" and identifier ~= "Start" then
				cameraSystemClass[identifier] = item
			end
		end
	end

	cameraSystemClass.InitializeObject = function(object)
		for _, initializeFunction in pairs(initializeFunctions) do
			initializeFunction(object)
		end
	end
	cameraSystemClass.StartObject = function(object)
		for _, startFunction in pairs(startFunctions) do
			startFunction(object)
		end
	end
end

function Loader.LoadUtilities(cameraSystemClass, utilities)
	cameraSystemClass.Utilities = {}
	for _, utility in pairs(utilities) do
		cameraSystemClass.Utilities[utility.Name] = require(utility)
	end
end

return Loader
