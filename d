-- Bundled by luabundle {"luaVersion":"5.1","version":"1.6.0"}
local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(require)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
if not shared then
	return warn("No shared, no script.")
end

repeat
	task.wait()
until game:IsLoaded()

local Water = require("water")

if shared.water then
	shared.water.detach()
end

shared.water = Water
shared.water.init()

end)
__bundle_register("water", function(require, _LOADED, __bundle_register, __bundle_modules)
local Water = {
	hitFromAnywhere = true,
	instantSpin = true,
	alwaysMaxServePower = true,
	silentUnlockedCamera = true,

	autoGuard = true,
	autoGuardDebugging = false,
	autoGuardTeleporting = false,
	autoGuardRedirectTowardsCenter = true,
}

local collectionService = game:GetService("CollectionService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local Logger = require("utility/logger")
local Maid = require("utility/maid")
local Hooking = require("utility/hooking")
local Gizmos = require("utility/gizmos")
local BallNetworking = require("utility/ball_networking")

local AutoGuard = require("auto_guard")

local Knit = require(replicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"))

local abilityController = nil

while not abilityController do
	abilityController = Knit.GetController("AbilityController")
	task.wait()
end

local styleController = nil

while not styleController do
	styleController = Knit.GetController("StyleController")
	task.wait()
end

local abilityService = nil

while not abilityService do
	abilityService = Knit.GetService("AbilityService")
	task.wait()
end

local styleService = nil

while not styleService do
	styleService = Knit.GetService("StyleService")
	task.wait()
end

local oldNameCall = nil
local oldAbilitySpin = nil
local oldStyleSpin = nil
local oldIndex = nil

local function onGetPartsInPart(...)
	if not Water.hitFromAnywhere then
		return oldNameCall(...)
	end

	local taggedBalls = collectionService.GetTagged(collectionService, "Ball")
	if not taggedBalls or #taggedBalls == 0 then
		return oldNameCall(...)
	end

	local ballParts = {}

	for _, taggedBall in next, taggedBalls do
		local ballPart = taggedBall.FindFirstChildWhichIsA(taggedBall, "BasePart")
		if not ballPart then
			continue
		end

		table.insert(ballParts, ballPart)
	end

	return ballParts
end

local function onSetInteract(data)
	if not Water.autoGuardRedirectTowardsCenter then
		return
	end

	if not checkcaller() then
		return
	end

	local map = workspace.FindFirstChild(workspace, "Map")
	if not map then
		return
	end

	local ballNoCollide = map.FindFirstChild(map, "BallNoCollide")
	if not ballNoCollide then
		return
	end

	local boundaries = ballNoCollide.FindFirstChild(ballNoCollide, "Boundaries")
	if not boundaries then
		return
	end

	local localPlayer = players.LocalPlayer
	local character = localPlayer.Character
	if not character then
		return
	end

	local humanoidRootPart = character.FindFirstChild(character, "HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	local nearestPart = nil
	local nearestDistance = nil

	for _, part in next, boundaries.GetChildren(boundaries) do
		if not game.IsA(part, "BasePart") then
			continue
		end

		local distance = (part.Position - humanoidRootPart.Position).Magnitude

		if nearestDistance and distance > nearestDistance then
			continue
		end

		nearestPart = part
		nearestDistance = distance
	end

	if not nearestPart then
		return
	end

	local snappedPosition = Vector3.new(nearestPart.Position.X, humanoidRootPart.Position.Y, nearestPart.Position.Z)

	data["LookVector"] = (snappedPosition - humanoidRootPart.Position).Unit
end

local function onInteractInvokeServer(...)
	local args = { ... }
	local data = args[2]

	if Water.silentUnlockedCamera then
		data["LookVector"] = workspace.CurrentCamera.CFrame.LookVector
	end

	if data["Move"] == "Set" then
		onSetInteract(data)
	end

	return oldNameCall(unpack(args))
end

local function onServeInvokeServer(...)
	local args = { ... }

	---@note: clamped on server anyway
	args[3] = Water.alwaysMaxServePower and math.huge or args[3]

	return oldNameCall(unpack(args))
end

local function onDiveMoveDirection(...)
	if not checkcaller() then
		return oldIndex(...)
	end

	return AutoGuard.wantedDiveDirection
end

local function onIndex(...)
	local args = { ... }
	local index = args[2]

	if index == "MoveDirection" and debug.getinfo(3).name == "Dive" then
		return onDiveMoveDirection(...)
	end
	return oldIndex(...)
end

local function onNameCall(...)
	local args = { ... }
	local self = args[1]

	if getnamecallmethod() == "InvokeServer" then
		if self.name == "Interact" then
			return onInteractInvokeServer(...)
		end

		if self.Name == "Serve" then
			return onServeInvokeServer(...)
		end

		return oldNameCall(...)
	end

	if getnamecallmethod() == "DistanceFromCharacter" then
		return Water.hitFromAnywhere and 0.0 or oldNameCall(...)
	end

	if getnamecallmethod() == "GetPartsInPart" then
		return onGetPartsInPart(...)
	end

	return oldNameCall(...)
end

local function onAbilitySpin(...)
	local args = { ... }

	if Water.instantSpin then
		return abilityService:Roll(args[2] or false)
	end

	return oldAbilitySpin(...)
end

local function onStyleSpin(...)
	local args = { ... }

	if Water.instantSpin then
		return styleService:Roll(args[2] or false)
	end

	return oldStyleSpin(...)
end

function Water.init()
	oldNameCall = Hooking.metamethod(game, "__namecall", onNameCall)
	oldIndex = Hooking.metamethod(game, "__index", onIndex)
	oldAbilitySpin = Hooking.func(abilityController.Spin, onAbilitySpin)
	oldStyleSpin = Hooking.func(styleController.Spin, onStyleSpin)

	Gizmos.init()
	BallNetworking.init()
	AutoGuard.init()

	Logger.warn("Water has initialized. Hello, ServerScriptService.AnticheatService logging :)")
end

function Water.detach()
	Maid.cleanAll()

	Logger.warn("Water has been detached.")
end

return Water

end)
__bundle_register("auto_guard", function(require, _LOADED, __bundle_register, __bundle_modules)
local AutoGuard = { wantedDiveDirection = Vector3.zero }

local players = game:GetService("Players")
local collectionService = game:GetService("CollectionService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local Maid = require("utility/maid")
local Gizmos = require("utility/gizmos")
local Sheet = require("utility/sheet")
local BallNetworking = require("utility/ball_networking")

local GameMode = require(replicatedStorage:WaitForChild("Configuration"):WaitForChild("Gamemode"))
local Game = require(replicatedStorage:WaitForChild("Configuration"):WaitForChild("Game"))
local Physics = require(replicatedStorage:WaitForChild("Common"):WaitForChild("Physics"))
local Knit = require(replicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"))

local gameController = nil

while not gameController do
	gameController = Knit.GetController("GameController")
	task.wait()
end

local autoGuardMaid = Maid.new()

local ballHistory = {}
local BALL_HISTORY_MAX_POINTS = 500

local predictedLandingHistory = {}
local PREDICTED_LANDING_MAX_POINTS = 5
local PREDICTED_LANDING_TOO_CLOSE_LIMIT = 0.5

local PREDICTION_TIME_STEP = 1 / 60
local PREDICTION_MAX_TIME = 5.0
local BALL_MAGNITUDE_LIMIT = 1023
local FLOOR_Y_LIMIT = -4.778
local COURT_TOO_LOW_THRESHOLD = 10.0

local LANDING_SPOT_DISTANCE_THRESHOLD = 12.5
local ACTION_TOO_FAR_LIMIT = 30.0
local SUPER_FAST_BALL_THRESHOLD = 75.0
local EXTREMELY_FAST_BALL_THRESHOLD = 100.0
local TOO_FAR_FROM_HEAD_LIMIT = 5.0
local SET_TOO_FAR_LIMIT = 20.0

local function isStateValid(state)
	for _, check in next, state.checks do
		if not check.value then
			return false
		end
	end

	return true
end

local function determineHitType(context, state)
	local landingPosition = state.predictedLandingData and state.predictedLandingData.position
	local humanoidRootPart = context.humanoidRootPart

	local distanceToLandingSpot = (landingPosition - humanoidRootPart.Position).Magnitude
	local distanceToBall = (context.ballCFrame.Position - humanoidRootPart.Position).Magnitude
	local ballSpeed = context.ballVelocity.Magnitude

	if distanceToLandingSpot > LANDING_SPOT_DISTANCE_THRESHOLD and ballSpeed > SUPER_FAST_BALL_THRESHOLD then
		return "Dive"
	end

	if distanceToBall > SET_TOO_FAR_LIMIT then
		return "Dive"
	end

	return "Set"
end

local function predictBallLanding(context)
	local position = context.ballCFrame.Position
	local velocity = context.ballVelocity
	local court = context.court

	local gravityMultiplier = context.gravityMultiplier or 1.0
	local acceleration = Vector3.zero
	local jerk = Vector3.zero

	local filter = collectionService:GetTagged("BallNoCollide")

	filter[#filter + 1] = context.ball

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = filter

	local timeStep = 0

	while timeStep < PREDICTION_MAX_TIME do
		local movement = (velocity - Vector3.new(0, 1, 0)) * PREDICTION_TIME_STEP

		if movement.Magnitude > BALL_MAGNITUDE_LIMIT then
			movement = movement.Unit * BALL_MAGNITUDE_LIMIT
		end

		if movement ~= movement then
			movement = Vector3.zero
		end

		if position.Y <= FLOOR_Y_LIMIT then
			position = position + Vector3.new(0, 1, 0) * (Game.Physics.Radius + FLOOR_Y_LIMIT - position.Y)
		end

		local result = workspace:Spherecast(position, Game.Physics.Radius, movement, raycastParams)

		if result and result.Instance and result.Instance.Name == "Invisible" then
			result = nil
		end

		if result then
			return { position = result.Position, instance = result.Instance }
		end

		local gravityDelta = PREDICTION_TIME_STEP * gravityMultiplier * Game.Physics.Gravity
		local newVelocity = velocity
			- Vector3.new(0, 1, 0) * gravityDelta
			+ PREDICTION_TIME_STEP * acceleration
			+ (PREDICTION_TIME_STEP ^ 2) * 0.5 * jerk

		position = newVelocity * PREDICTION_TIME_STEP + position
		velocity = newVelocity
		timeStep = timeStep + PREDICTION_TIME_STEP

		if position.Y < court.Position.Y - COURT_TOO_LOW_THRESHOLD then
			break
		end
	end

	return nil
end

local function updateBallHistory(context)
	table.insert(ballHistory, {
		position = context.ballCFrame.Position,
		velocity = context.ballVelocity,
	})

	while #ballHistory > BALL_HISTORY_MAX_POINTS do
		table.remove(ballHistory, 1)
	end
end

local function recordPredictedLand(predictedLandingData)
	local lastPrediction = predictedLandingHistory[#predictedLandingHistory]
	local predictedLandingPosition = predictedLandingData.position

	if
		lastPrediction
		and (lastPrediction.position - predictedLandingPosition).Magnitude < PREDICTED_LANDING_TOO_CLOSE_LIMIT
	then
		return
	end

	table.insert(predictedLandingHistory, predictedLandingData)

	while #predictedLandingHistory > PREDICTED_LANDING_MAX_POINTS do
		table.remove(predictedLandingHistory, 1)
	end
end

function AutoGuard.render(context, state)
	local ballPosition = context.ballCFrame.Position
	local ballVelocity = context.ballVelocity
	local predictedLandingData = state.predictedLandingData

	Gizmos.setColor3(predictedLandingData ~= nil and Color3.new(0, 1, 0) or Color3.new(1, 0, 0))
	Gizmos.drawRay(ballPosition, ballVelocity)

	if predictedLandingData ~= nil then
		recordPredictedLand(predictedLandingData)
	end

	Gizmos.setPosition(ballPosition + Vector3.new(0, 5, 0))
	Gizmos.setColor3(state.isValid and Color3.new(0, 1, 0) or Color3.new(1, 0, 0))

	local statusSheet = Sheet.new()

	statusSheet:append("Ball speed", string.format("%.2f studs/s", ballVelocity.Magnitude))
	statusSheet:append(
		"Ball distance",
		string.format("%.2f studs", (ballPosition - context.humanoidRootPart.Position).Magnitude)
	)

	for _, check in next, state.checks do
		statusSheet:append(check.label, check.value)
	end

	Gizmos.drawText(string.format("Auto guard status (%s)", state.hitType) .. statusSheet:build())

	for _, data in next, predictedLandingHistory do
		Gizmos.setColor3(Color3.new(0, 1, 1))
		Gizmos.setPosition(data.position)
		Gizmos.setThickness(1.0)
		Gizmos.drawPoint()

		Gizmos.setPosition(data.position + Vector3.new(0, 3, 0))

		local landingSheet = Sheet.new()

		landingSheet:append(
			"Landing position",
			string.format("(%.2f, %.2f, %.2f)", data.position.X, data.position.Y, data.position.Z)
		)
		landingSheet:append(
			"Distance from you",
			string.format("%.2f studs", (context.humanoidRootPart.Position - data.position).Magnitude)
		)
		landingSheet:append("Touched instance", data.instance and data.instance.Name or "nil")

		Gizmos.drawText(landingSheet:build())
	end

	local lastHitPosition = context.lastHitPosition

	if lastHitPosition and lastHitPosition.Magnitude > 0 then
		Gizmos.setPosition(lastHitPosition)
		Gizmos.setColor3(Color3.new(1, 0, 1))
		Gizmos.setThickness(1.0)
		Gizmos.drawPoint()

		local lastHitSheet = Sheet.new()

		lastHitSheet:append(
			"Hit position",
			string.format("(%.2f, %.2f, %.2f)", lastHitPosition.X, lastHitPosition.Y, lastHitPosition.Z)
		)
		lastHitSheet:append("Last hitter", tostring(context.lastHitter))
		lastHitSheet:append("Previous hitter", tostring(context.previousHitter))
		lastHitSheet:append("Hit type", tostring(context.lastHitType))
		lastHitSheet:append("Hit time", string.format("%.2f", context.lastHitTimestamp or 0.0))

		Gizmos.setPosition(lastHitPosition + Vector3.new(0, 5, 0))
		Gizmos.drawText("Last hit sheet..." .. lastHitSheet:build())
	end

	updateBallHistory(context)

	for idx, point in ipairs(ballHistory) do
		local age = (idx - 1) / #ballHistory
		Gizmos.setColor3(Color3.new(1.0 - age * 0.5, 0.3, age * 0.7))
		Gizmos.setPosition(point.position)
		Gizmos.setThickness(0.5)
		Gizmos.drawPoint()
	end

	local nearestBoundaryPart = context.nearestBoundaryPart
	local humanoidRootPart = context.humanoidRootPart

	if nearestBoundaryPart then
		local snappedPosition =
			Vector3.new(nearestBoundaryPart.Position.X, humanoidRootPart.Position.Y, nearestBoundaryPart.Position.Z)

		Gizmos.setPosition(nearestBoundaryPart.Position)
		Gizmos.setColor3(Color3.new(1, 1, 0))
		Gizmos.drawRay(humanoidRootPart.Position, (snappedPosition - humanoidRootPart.Position).Unit)
	end
end

function AutoGuard.update()
	local savedBallHistory = ballHistory
	local savedPredictedLandingHistory = predictedLandingHistory

	ballHistory = {}
	predictedLandingHistory = {}

	local localPlayer = players.LocalPlayer
	local character = localPlayer.Character
	if not character then
		return
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	local taggedBalls = collectionService:GetTagged("Ball")
	if not taggedBalls or #taggedBalls == 0 then
		return
	end

	local map = workspace:FindFirstChild("Map")
	if not map then
		return
	end

	local ballCollideOnly = map:FindFirstChild("BallCollideOnly")
	if not ballCollideOnly then
		return
	end

	local net = ballCollideOnly:FindFirstChild("Net")
	if not net then
		return
	end

	local court = map:FindFirstChild("Court")
	if not court then
		return
	end

	local isInTraining = GameMode.Current() == GameMode.Types.Training
	if not isInTraining and not localPlayer.Team then
		return
	end

	local firstBall = taggedBalls[1]
	if not firstBall then
		return
	end

	local firstBallPart = firstBall:FindFirstChildWhichIsA("BasePart")
	if not firstBallPart then
		return
	end

	local head = character:FindFirstChild("Head")
	if not head then
		return
	end

	local ballNoCollide = map:FindFirstChild("BallNoCollide")
	if not ballNoCollide then
		return
	end

	local boundaries = ballNoCollide:FindFirstChild("Boundaries")
	if not boundaries then
		return
	end

	ballHistory = savedBallHistory
	predictedLandingHistory = savedPredictedLandingHistory

	local networkedBallData = BallNetworking.networkedBallData
	local context = {
		localPlayer = localPlayer,
		character = character,
		humanoidRootPart = humanoidRootPart,
		team = localPlayer.Team,
		ball = firstBall,
		ballPart = firstBallPart,
		ballCFrame = networkedBallData and networkedBallData.cframe or firstBallPart.CFrame,
		ballVelocity = networkedBallData and networkedBallData.velocity or Vector3.zero,
		---@todo: technically networked, go get it?
		gravityMultiplier = 1.0,
		---@note: this is not networked.
		acceleration = Vector3.zero,
		jerk = Vector3.zero,
		map = map,
		court = court,
		net = net,
		isInTraining = isInTraining,
		servesInRow = replicatedStorage:GetAttribute("ServesInRow") or 0,
		lastHitTimestamp = replicatedStorage:GetAttribute("LastHitTimestamp") or 0.0,
		lastHitPosition = replicatedStorage:GetAttribute("LastHitPosition") or Vector3.new(0.0, 0.0, 0.0),
		teamHitStreak = replicatedStorage:GetAttribute("TeamHitStreak") or 0,
		lastHitter = replicatedStorage:GetAttribute("LastHitter"),
		lastHitTeam = replicatedStorage:GetAttribute("LastHitTeam"),
		servedByTeam = replicatedStorage:GetAttribute("ServedByTeam"),
		previousHitter = replicatedStorage:GetAttribute("PreviousHitter"),
		lastHitType = replicatedStorage:GetAttribute("LastHitType"),
		isBallInPlay = replicatedStorage:GetAttribute("IsBallInPlay"),
	}

	local nearestBoundaryPart = nil
	local nearestBoundaryDistance = nil

	for _, part in next, boundaries:GetChildren() do
		if not part:IsA("BasePart") then
			continue
		end

		local distance = (part.Position - humanoidRootPart.Position).Magnitude

		if nearestBoundaryDistance and distance > nearestBoundaryDistance then
			continue
		end

		nearestBoundaryPart = part
		nearestBoundaryDistance = distance
	end

	context.nearestBoundaryPart = nearestBoundaryPart

	local predictedLandingData = predictBallLanding(context)

	local state = {
		predictedLandingData = predictedLandingData,
		checks = {
			isTeamValid = {
				label = "Is team valid?",
				value = (localPlayer.Team ~= nil or GameMode.Current() == GameMode.Types.Training),
			},
			isBallOnCorrectSide = {
				label = "Is ball on correct side?",
				value = Physics.isPointOnTeamSide(localPlayer, context.ballCFrame.Position, nil),
			},
			isBallInPlay = {
				label = "Is ball in play?",
				value = context.isBallInPlay,
			},
			isNotAerial = {
				label = "Is not aerial?",
				value = not gameController.IsJumping:get(),
			},
			isLastTouchValid = {
				label = "Is last touch valid?",
				value = context.lastHitTeam and context.lastHitTeam ~= localPlayer.Team.Name,
			},
			isLandingValid = {
				label = "Is landing valid?",
				value = predictedLandingData and predictedLandingData.instance.Name == "Court",
			},
			isBallInDistance = {
				label = "Is ball in distance?",
				value = (context.ballCFrame.Position - humanoidRootPart.Position).Magnitude <= ACTION_TOO_FAR_LIMIT,
			},
			isBallInVerticalDistanceFromHead = {
				label = "Is ball in vertical distance from head?",
				value = math.abs(context.ballCFrame.Position.Y - head.Position.Y) <= TOO_FAR_FROM_HEAD_LIMIT,
			},
		},
	}

	---@note: these checks are reliant on the current ball position and at high velocities, it can be unreliable.
	-- we simply need to give ourselves enough time to run these checks, else we risk not defending properly.
	-- 1. we are in very close distance.
	-- 2. the ball is going extremely fast on us.
	if
		predictedLandingData
		and (predictedLandingData.position - humanoidRootPart.Position).Magnitude <= SET_TOO_FAR_LIMIT
		and context.ballVelocity.Magnitude > EXTREMELY_FAST_BALL_THRESHOLD
	then
		state.checks.isBallOnCorrectSide.value = "Skipped (unreliable at high speeds)"
		state.checks.isBallInVerticalDistanceFromHead.value = "Skipped (unreliable at high speeds)"
	end

	state.isValid = isStateValid(state)
	state.hitType = determineHitType(context, state)

	if shared.water.autoGuardDebugging then
		AutoGuard.render(context, state)
	end

	if not state.isValid then
		return
	end

	-- Before calling, set thread identity so we don't error from requiring
	setthreadidentity(2)

	if shared.water.autoGuardTeleporting then
		humanoidRootPart.CFrame = CFrame.new(predictedLandingData.position + Vector3.new(0, 5, 0))
	end

	AutoGuard.wantedDiveDirection = (predictedLandingData.position - humanoidRootPart.Position).Unit

	if state.hitType == "Set" then
		gameController:DoMove("Set")
	end

	if state.hitType == "Dive" then
		gameController:Dive()
	end
end

function AutoGuard.init()
	if not shared.water.autoGuard then
		return
	end

	autoGuardMaid:mark(runService.RenderStepped:Connect(AutoGuard.update))
end

return AutoGuard

end)
__bundle_register("utility/ball_networking", function(require, _LOADED, __bundle_register, __bundle_modules)
local BallNetworking = {
	networkedBallData = nil,
}

local replicatedStorage = game:GetService("ReplicatedStorage")

local Maid = require("utility/maid")

local ballNetworkingMaid = Maid.new()

local zapFolder = replicatedStorage:WaitForChild("ZAP")
local ballZapReliable = zapFolder:WaitForChild("BALL_ZAP_RELIABLE")

local function onBallReplication(dataBuffer)
	local readerPosition = 0

	local function zapRead(numBytes)
		local pos = readerPosition
		readerPosition = readerPosition + numBytes
		return pos
	end

	local id = buffer.readu8(dataBuffer, zapRead(1))

	if id ~= 1 then
		error("unknown event id")
	end

	local x = buffer.readf32(dataBuffer, zapRead(4))
	local y = buffer.readf32(dataBuffer, zapRead(4))
	local z = buffer.readf32(dataBuffer, zapRead(4))
	local vector = Vector3.new(x, y, z)

	local axisX = buffer.readf32(dataBuffer, zapRead(4))
	local axisY = buffer.readf32(dataBuffer, zapRead(4))
	local axisZ = buffer.readf32(dataBuffer, zapRead(4))
	local axisVector = Vector3.new(axisX, axisY, axisZ)

	local cframe = nil

	if axisVector.Magnitude ~= 0 then
		cframe = CFrame.fromAxisAngle(axisVector, axisVector.Magnitude) + vector
	else
		cframe = CFrame.new(vector)
	end

	local velocityX = buffer.readf32(dataBuffer, zapRead(4))
	local velocityY = buffer.readf32(dataBuffer, zapRead(4))
	local velocityZ = buffer.readf32(dataBuffer, zapRead(4))
	local velocityVector = Vector3.new(velocityX, velocityY, velocityZ)

	BallNetworking.networkedBallData = {
		cframe = cframe,
		velocity = velocityVector,
	}
end

function BallNetworking.init()
	ballNetworkingMaid:mark(ballZapReliable.OnClientEvent:Connect(onBallReplication))
end

return BallNetworking

end)
__bundle_register("utility/maid", function(require, _LOADED, __bundle_register, __bundle_modules)
local Maid = {}
Maid.__index = Maid

local maidList = {}

function Maid.new()
	local self = setmetatable({
		_tasks = {},
	}, Maid)

	table.insert(maidList, self)

	return self
end

function Maid:__index(index)
	if Maid[index] then
		return Maid[index]
	else
		return self._tasks[index]
	end
end

function Maid:__newindex(index, newTask)
	if Maid[index] ~= nil then
		return warn(("'%s' is reserved"):format(tostring(index)), 2)
	end

	local tasks = self._tasks
	local oldTask = tasks[index]

	if oldTask == newTask then
		return
	end

	tasks[index] = newTask

	if oldTask then
		if typeof(oldTask) == "thread" then
			return coroutine.status(oldTask) == "suspended" and task.cancel(oldTask) or nil
		end

		if type(oldTask) == "function" then
			oldTask()
		elseif typeof(oldTask) == "RBXScriptConnection" then
			oldTask:Disconnect()
		elseif typeof(oldTask) == "Instance" and oldTask:IsA("Tween") then
			oldTask:Pause()
			oldTask:Cancel()
			oldTask:Destroy()
		elseif oldTask.Destroy then
			oldTask:Destroy()
		elseif oldTask.detach then
			oldTask:detach()
		end
	end
end

function Maid:mark(task)
	self:add(task)
	return task
end

function Maid:add(task)
	if not task then
		return error("task cannot be false or nil", 2)
	end

	local taskId = #self._tasks + 1
	self[taskId] = task

	return taskId
end

function Maid:clean()
	local tasks = self._tasks

	for index, task in pairs(tasks) do
		if typeof(task) == "RBXScriptConnection" then
			tasks[index] = nil
			task:Disconnect()
		end
	end

	local index, _task = next(tasks)

	while _task ~= nil do
		tasks[index] = nil

		if typeof(_task) == "thread" then
			if coroutine.status(_task) == "suspended" then
				task.cancel(_task)
			end
		else
			if type(_task) == "function" then
				_task()
			elseif typeof(_task) == "RBXScriptConnection" then
				_task:Disconnect()
			elseif typeof(_task) == "Instance" and _task:IsA("Tween") then
				_task:Pause()
				_task:Cancel()
				_task:Destroy()
			elseif _task.Destroy then
				_task:Destroy()
			elseif _task.detach then
				_task:detach()
			end
		end

		index, _task = next(tasks)
	end
end

function Maid.cleanAll()
	for _, maid in next, maidList do
		maid:clean()
	end
end

return Maid

end)
__bundle_register("utility/sheet", function(require, _LOADED, __bundle_register, __bundle_modules)
local Sheet = {}
Sheet.__index = Sheet

function Sheet:build()
	local text = ""

	for _, entry in ipairs(self.data) do
		local representation = nil

		if typeof(entry.value) == "boolean" then
			representation = entry.value and "✓" or "X"
		else
			representation = tostring(entry.value)
		end

		text = text .. "\n" .. entry.label .. ": " .. representation
	end

	return text
end

function Sheet:append(label, value)
	self.data[#self.data + 1] = { label = label, value = value }
end

function Sheet.new()
	return setmetatable({ data = {} }, Sheet)
end

return Sheet

end)
__bundle_register("utility/gizmos", function(require, _LOADED, __bundle_register, __bundle_modules)
local Gizmos = {}

local runService = game:GetService("RunService")

local Maid = require("utility/maid")

local gizmosMaid = Maid.new()
local gizmosQueue = {}
local gizmosPosition = Vector3.new(0, 0, 0)
local gizmosColor3 = Color3.new(1, 1, 1)
local gizmosThickness = 1.0

local POINT_SCALE = 1

local processingQueue = false
local gizmosCounter = 0

local function setVisible(queue, state)
	for _, instance in ipairs(queue) do
		if instance:IsA("BillboardGui") then
			instance.Enabled = state
		else
			instance.Visible = state
		end
	end
end

function Gizmos.init()
	gizmosMaid:mark(runService.RenderStepped:Connect(Gizmos.render))
end

function Gizmos.styleInstance(adornment)
	adornment.Color3 = gizmosColor3
	adornment.AlwaysOnTop = true
	adornment.Adornee = workspace.Terrain
	adornment.AdornCullingMode = Enum.AdornCullingMode.Automatic
	adornment.Visible = false
	adornment.ZIndex = 1
end

function Gizmos.createInstance(className)
	gizmosCounter = gizmosCounter + 1

	local identifier = className .. "_" .. gizmosCounter

	local cache = gizmosMaid[identifier] or Instance.new(className, workspace)

	gizmosMaid[identifier] = cache

	table.insert(gizmosQueue, cache)

	return cache
end

function Gizmos.setColor3(color3)
	gizmosColor3 = color3
end

function Gizmos.setPosition(position)
	gizmosPosition = position
end

function Gizmos.setThickness(value)
	gizmosThickness = value
end

function Gizmos.drawPoint(position)
	local adornment = Gizmos.createInstance("SphereHandleAdornment")

	Gizmos.styleInstance(adornment)

	adornment.Radius = gizmosThickness * POINT_SCALE * 0.5
	adornment.CFrame = CFrame.new(gizmosPosition + (position or Vector3.zero))
end

function Gizmos.drawArrow(from, to)
	local coneHeight = gizmosThickness * POINT_SCALE
	local distance = math.abs((to - from).Magnitude - coneHeight)
	local orientation = CFrame.lookAt(from, to)

	local adornmentLine = Gizmos.createInstance("CylinderHandleAdornment")

	Gizmos.styleInstance(adornmentLine)

	adornmentLine.Radius = gizmosThickness * 0.5
	adornmentLine.InnerRadius = 0
	adornmentLine.Height = distance
	adornmentLine.CFrame = orientation * CFrame.new(0, 0, -distance * 0.5)

	local adornmentCone = Gizmos.createInstance("ConeHandleAdornment")

	Gizmos.styleInstance(adornmentCone)

	adornmentCone.Height = coneHeight
	adornmentCone.Radius = coneHeight * 0.5
	adornmentCone.CFrame = orientation * CFrame.new(0, 0, -distance)
end

function Gizmos.drawRay(from, direction)
	Gizmos.drawArrow(from, from + direction)
end

function Gizmos.drawText(text)
	local billboard = Gizmos.createInstance("BillboardGui")
	billboard.Adornee = workspace.Terrain
	billboard.AlwaysOnTop = true
	billboard.StudsOffsetWorldSpace = gizmosPosition
	billboard.Size = UDim2.fromOffset(200, 200)
	billboard.ClipsDescendants = false
	billboard.LightInfluence = 0
	billboard.Name = "GizmosBillboardGui"

	local label = Gizmos.createInstance("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.RobotoMono
	label.TextColor3 = gizmosColor3
	label.TextScaled = false
	label.TextSize = 14
	label.TextStrokeTransparency = 0.0
	label.Text = text
	label.Parent = billboard
	label.Name = "GizmosTextLabel"
end

function Gizmos.render()
	if processingQueue then
		return
	end

	local oldQueue = gizmosQueue

	gizmosQueue = {}
	gizmosCounter = 0

	setVisible(oldQueue, true)

	processingQueue = true

	runService.RenderStepped:Wait()

	processingQueue = false

	setVisible(oldQueue, false)
end

return Gizmos

end)
__bundle_register("utility/hooking", function(require, _LOADED, __bundle_register, __bundle_modules)
local Hooking = {}

local Maid = require("utility/maid")

local hookingMaid = Maid.new()

function Hooking.metamethod(object, methodName, func)
	local old = hookmetamethod(object, methodName, func)

	hookingMaid:add(function()
		hookmetamethod(object, methodName, old)
	end)

	return old
end

function Hooking.func(target, func)
	local old = hookfunction(target, func)

	hookingMaid:add(function()
		hookfunction(target, old)
	end)

	return old
end

return Hooking

end)
__bundle_register("utility/logger", function(require, _LOADED, __bundle_register, __bundle_modules)
local Logger = {}

local function buildPrefixString(str)
	return string.format("[water]: %s", str)
end

function Logger.warn(str, ...)
	warn(string.format(buildPrefixString(str), ...))
end

function Logger.print(str, ...)
	print(string.format(buildPrefixString(str), ...))
end

return Logger

end)
return __bundle_require("__root")
