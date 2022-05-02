local MODULE = {}

--// CONSTANTS //--

local COLLECTION_SERVICE = game:GetService("CollectionService")

--// VARIABLES //--



--// INITIALIZER //--

function MODULE:Initialize()
    self.FilterNonCanCollideBaseParts = self.Configurations.Defaults.FilterNonCanCollideBaseParts
    self.FilterTransparentBaseParts = self.Configurations.Defaults.FilterTransparentBaseParts
    self.BasePartFilterTransparencyThreshold = self.Configurations.Defaults.BasePartFilterTransparencyThreshold
    self.FilterTaggedParts = self.Configurations.Defaults.FilterTaggedParts
    self.IsUsingCustomBasePartFilterFunction = self.Configurations.Defaults.IsUsingCustomBasePartFilterFunction
    self.CustomBasePartFilterFunctionEnabled = self.Utilities.Signal.new()
    self.CustomBasePartFilterFunctionDisabled = self.Utilities.Signal.new()

    self.BasePartFilterFunction = self.Configurations.Defaults.BasePartFilterFunction
end

--// METHODS //--

function MODULE:EnableCustomBasePartFilterFunction(basePartFilterFunction)
    assert(basePartFilterFunction ~= nil, "OTS Camera System Argument Error: Argument 1 nil or missing")
    assert(typeof(basePartFilterFunction) == "function", "OTS Camera System Argument Error: function expected, got " .. typeof(basePartFilterFunction))

    self.BasePartFilterFunction = basePartFilterFunction
    self.CustomBasePartFilterFunctionEnabled:Fire()
end

function MODULE:DisableCustomBasePartFilterFunction()
    self.BasePartFilterFunction = function(basePart)
        self:DefaultBasePartFilterFunction(basePart)
    end
    self.CustomBasePartFilterFunctionDisabled:Fire()
end

function MODULE:DefaultBasePartFilterFunction(basePart)
    if (self.FilterNonCanCollideBaseParts) and not (basePart.CanCollide) then
        return true
    end
    if (self.FilterTransparentBaseParts) and (basePart.Transparency < self.BasePartFilterTransparencyThreshold) then
        return true
    end
end

return MODULE