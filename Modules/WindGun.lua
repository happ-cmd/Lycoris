---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	timing.ffh = true

	local action = Action.new()
	action._when = 400
	action._type = "Parry"
	action.name = string.format("(%.2f) Dynamic Wind Gun Timing", self.track.Speed)
	action.hitbox = Vector3.new(15, 20, 20)

	return self:action(timing, action)
end
