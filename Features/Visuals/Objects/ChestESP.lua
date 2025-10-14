---@module Features.Visuals.Objects.ModelESP
local ModelESP = require("Features/Visuals/Objects/ModelESP")

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

---@class ChestESP: ModelESP
local ChestESP = setmetatable({}, { __index = ModelESP })
ChestESP.__index = ChestESP
ChestESP.__type = "ChestESP"

---Update ChestESP.
---@param self ChestESP
ChestESP.update = LPH_NO_VIRTUALIZE(function(self)
	local model = self.model

	if Configuration.idToggleValue(self.identifier, "HideIfOpened") and not model:HasTag("ClosedChest") then
		return self:visible(false)
	end

	ModelESP.update(self, {})
end)

---Create new ChestESP object.
---@param identifier string
---@param model Model
---@param label string
function ChestESP.new(identifier, model, label)
	return setmetatable(ModelESP.new(identifier, model, label), ChestESP)
end

-- Return ChestESP module.
return ChestESP
