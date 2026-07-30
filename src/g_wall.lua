local GPhysicsObject = require("src.core.g_physics_object")
local Tags = require("src.tags")

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
	---@type GWall
	local obj = GPhysicsObject.new(self, x, y, width, height)

	obj:addTag(Tags.WALL)
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
