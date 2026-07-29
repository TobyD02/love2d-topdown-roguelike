local GPhysicsObject = require("src.g_physics_object")
local Constants = require("constants")

---@class GWall : GPhysicsObject
local GWall = {}
GWall.__index = GWall

setmetatable(GWall, { __index = GPhysicsObject })

---@generic TWall
---@param x number
---@param y number
---@param width number
---@param height number
---@return TWall
function GWall:new(x, y, width, height)
	local obj = GPhysicsObject.new(self, Constants.TYPE_WALL, x, y, width, height)
	obj.x = x
	obj.y = y
	obj.width = width
	obj.height = height
	return obj
end

---@param self GWall
function GWall:draw()
	GPhysicsObject.draw(self) -- Call parent draw

	love.graphics.setColor(0.4, 0.4, 0.4)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return GWall
