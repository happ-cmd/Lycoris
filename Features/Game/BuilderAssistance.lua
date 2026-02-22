-- BuilderAssistance module.
local BuilderAssistance = {}

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Utility.JSON
local JSON = require("Utility/JSON")

---@module Features.Visuals.Objects.BuilderData
local BuilderData = require("Features/Visuals/Objects/BuilderData")

---@module Features.Visuals.Visuals
local Visuals = require("Features/Visuals/Visuals")

---@module GUI.Library
local Library = require("GUI/Library")

---Initialize Build Assistance section.
---@param groupbox table
function BuilderAssistance.initBuildAssistanceSection(groupbox)
	local buildAssistanceToggle = groupbox:AddToggle("BuildAssistance", {
		Text = "Build Assistance",
		Tooltip = "Visual assistance for selecting talents, progressing a build, and more.",
		Default = false,
	})

	local buildAssistanceDepBox = groupbox:AddDependencyBox()

	local sdoToggle = buildAssistanceDepBox:AddToggle("ShrineDetectionOverride", {
		Text = "Shrine Detection Override",
		Tooltip = "Auto-detection for shrine can be wrong especially when it refunds your points. You can use this to override the current state.",
		Default = true,
	})

	local sdoDepBox = buildAssistanceDepBox:AddDependencyBox()

	sdoDepBox:AddDropdown("ShrineOverrideState", {
		Text = "Shrine Override State",
		Tooltip = "The shrine state to override to.",
		Default = 1,
		Values = { "Pre-Shrine", "Post-Shrine", "Must Shrine" },
	})

	sdoDepBox:SetupDependencies({
		{ sdoToggle, true },
	})

	buildAssistanceDepBox:AddInput("BuildAssistanceLink", {
		Text = "Build Assistance Link",
		Tooltip = "The builder link that will be used to assist with builds.",
		Placeholder = "Enter your builder link here.",
		Finished = true,
		Callback = function(value)
			local dresponse = request({
				Url = "https://deepwoken.co/api/proxy?url=https://api.deepwoken.co/get?type=all",
				Method = "GET",
				Headers = { ["Content-Type"] = "application/json" },
			})

			if not dresponse or not dresponse.Success or not dresponse.Body then
				return Logger.notify("Invalid response while fetching data response.")
			end

			local dsuccess, dresult = pcall(JSON.decode, dresponse.Body)
			if not dsuccess or not dresult then
				return Logger.notify("JSON error '%s' while deserializing data response.", dresult)
			end

			Logger.notify("Successfully fetched Deepwoken data.")

			local id = value:gsub("https://deepwoken.co/builder%?id=", ""):gsub(" ", ""):gsub("\n", "")
			local bresponse = request({
				Url = ("https://deepwoken.co/api/proxy?url=https://api.deepwoken.co/build?id=%s"):format(id),
				Method = "GET",
				Headers = { ["Content-Type"] = "application/json" },
			})

			if not bresponse or not bresponse.Success or not bresponse.Body then
				return Logger.notify("Invalid response while fetching builder response.")
			end

			local bsuccess, bresult = pcall(JSON.decode, bresponse.Body)
			if not bsuccess or not bresult then
				return Logger.notify("JSON error '%s' while deserializing builder response.", bresult)
			end

			Logger.notify("Successfully created BuilderData object.")

			Visuals.bdata = BuilderData.new(bresult, dresult)
		end,
	})

	buildAssistanceDepBox:SetupDependencies({
		{ buildAssistanceToggle, true },
	})
end

---Initialize Build Stealer section.
---@param groupbox table
function BuilderAssistance.initBuildStealerSection(groupbox)
	groupbox:AddToggle("BuildStealer", {
		Text = "Build Stealer",
		Tooltip = "Steal builds by hovering on them in the player list and pressing 'P' on your keyboard.",
		Default = false,
	})
end

---Initialize tab.
---@param window table
function BuilderAssistance.init(window)
	-- Create tab.
	local tab = window:AddTab("Builder Assistance")

	-- Initialize sections.
	BuilderAssistance.initBuildAssistanceSection(tab:AddDynamicGroupbox("Build Assistance"))
	BuilderAssistance.initBuildStealerSection(tab:AddDynamicGroupbox("Build Stealer"))
end

-- Return BuilderAssistance module.
return BuilderAssistance
