-- NearbyPlayers module
-- Displays the closest nearby player with their distance in studs

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

---@module Utility.InstanceWrapper
local InstanceWrapper = require("Utility/InstanceWrapper")

-- Module
local NearbyPlayers = {}

-- Services
local players = game:GetService("Players")

-- Update function for the nearby players display
---@param visualsMaid table
---@param renderStepped table
local function updateNearbyPlayers(visualsMaid, renderStepped)
	return function()
		local localPlayer = players.LocalPlayer
		if not localPlayer then
			return
		end

		local playerGui = localPlayer.PlayerGui
		if not playerGui then
			return
		end

		local character = localPlayer.Character
		if not character then
			return
		end

		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end

		-- Get or create screen GUI
		local screenGui = playerGui:FindFirstChild("NearbyPlayersGui")
		if not screenGui then
			screenGui = Instance.new("ScreenGui")
			screenGui.Name = "NearbyPlayersGui"
			screenGui.ResetOnSpawn = false
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
			screenGui.Parent = playerGui
			InstanceWrapper.mark(visualsMaid, "NearbyPlayersGui", screenGui)
		end

		-- Get or create text label
		local textLabel = screenGui:FindFirstChild("NearbyPlayersLabel")
		if not textLabel then
			textLabel = Instance.new("TextLabel")
			textLabel.Name = "NearbyPlayersLabel"
			textLabel.Size = UDim2.new(0, 300, 0, 50)
			textLabel.Position = UDim2.new(0.5, -150, 0, 20)
			textLabel.BackgroundTransparency = 1
			textLabel.TextScaled = true
			textLabel.Font = Enum.Font.GothamBold
			textLabel.Parent = screenGui

			-- Add black outline/stroke
			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.new(0, 0, 0)
			stroke.Thickness = 2
			stroke.Parent = textLabel
		end

		-- Update color from configuration
		textLabel.TextColor3 = Configuration.idOptionValue("ShowNearbyPlayers", "Color") or Color3.new(1, 1, 1)

		-- Find closest player
		local closestPlayer = nil
		local closestDistance = math.huge

		for _, player in pairs(players:GetPlayers()) do
			if player == localPlayer then
				continue
			end

			local otherChar = player.Character
			if not otherChar then
				continue
			end

			local otherHRP = otherChar:FindFirstChild("HumanoidRootPart")
			if not otherHRP then
				continue
			end

			local distance = (humanoidRootPart.Position - otherHRP.Position).Magnitude
			if distance < closestDistance then
				closestDistance = distance
				closestPlayer = player
			end
		end

		-- Update text
		if closestPlayer then
			local displayDistance = math.floor(closestDistance + 0.5) -- Round to nearest stud
			textLabel.Text = string.format("%s [%d studs]", closestPlayer.Name, displayDistance)
		else
			textLabel.Text = "No nearby players"
		end
	end
end

---Initialize nearby players display
---@param visualsMaid table
---@param renderStepped table
function NearbyPlayers.init(visualsMaid, renderStepped)
	local updateFunc = updateNearbyPlayers(visualsMaid, renderStepped)
	visualsMaid:mark(renderStepped:connect("Visuals_ShowNearbyPlayers", updateFunc))
end

-- Return NearbyPlayers module
return NearbyPlayers
