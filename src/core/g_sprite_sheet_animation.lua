local GTimer = require("src.core.g_timer")
---@class GSpriteSheetAnimation
---@field name string
---@field animationTimer GTimer
---@field animationIndexes number[]
---@field currentFrame number
local GSpriteSheetAnimation = {}
GSpriteSheetAnimation.__index = GSpriteSheetAnimation

---@generic TSpriteSheetAnimation : GSpriteSheetAnimation
---@param self TSpriteSheetAnimation
---@param name string
---@param framesPerSecond number
---@param animationIndexes number[]
function GSpriteSheetAnimation:new(name, framesPerSecond, animationIndexes)
	local obj = {
		name = name,
		animationTimer = GTimer:new(1 / framesPerSecond, true),
		animationIndexes = animationIndexes,
		currentFrame = 1,
	}

	setmetatable(obj, GSpriteSheetAnimation)
	return obj
end

---@param self GSpriteSheetAnimation
---@param dt number
function GSpriteSheetAnimation:update(dt)
	if #self.animationIndexes == 0 then
		return
	end

	self.animationTimer:update(dt)
	if self.animationTimer:isFinished() then
		self.currentFrame = self.currentFrame + 1
		if self.currentFrame > #self.animationIndexes then
			self.currentFrame = 1
		end

		self.animationTimer:start()
	end
end

---@param self GSpriteSheetAnimation
---@return number
function GSpriteSheetAnimation:getFrame()
	return self.currentFrame
end

return GSpriteSheetAnimation
