local gamera = require("lib.gamera.gamera")
local Constants = require("src.constants")
---@class GCamera
---@field target GEntity|nil
---@field gamera table
---@field scale number
local GCamera = {}
GCamera.__index = GCamera

---@param self GCamera
---@param target GEntity|nil
function GCamera:new(target)
	local obj = {
		gamera = gamera.new(0, 0, Constants.WORLD_WIDTH, Constants.WORLD_HEIGHT),
		target = target,
	}

	obj.scale = 1.0

	obj.gamera:setWindow(0, 0, Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)
	obj.gamera:setScale(obj.scale)

	setmetatable(obj, GCamera)
	return obj
end

---@param self GCamera
---@param dt number
function GCamera:update(dt)
	if self.target == nil then
		return
	end
	self.gamera:setPosition(self.target.x, self.target.y)
end

---@param self GCamera
---@param fn function
function GCamera:draw(fn)
	self.gamera:draw(fn)
end

return GCamera
