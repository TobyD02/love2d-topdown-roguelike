---@class GTimer
---@field waitTime number
---@field timeLeft number
---@field active boolean
local GTimer = {}
GTimer.__index = GTimer

---@param self GTimer
---@param waitTime number
---@param active boolean|nil
function GTimer:new(waitTime, active)
	local timeLeft = 0
	if active == nil then
		active = false
	end
	if active then
		timeLeft = waitTime
	end

	local obj = {
		waitTime = waitTime,
		active = active,
		timeLeft = timeLeft,
	}

	setmetatable(obj, self)
	return obj
end

function GTimer:update(dt)
	if self.active then
		self.timeLeft = self.timeLeft - dt
		if self.timeLeft <= 0 then
			self.timeLeft = 0
			self.active = false
		end
	end
end

function GTimer:start()
	self.timeLeft = self.waitTime
	self.active = true
end

function GTimer:isFinished()
	return self.timeLeft <= 0
end

return GTimer
