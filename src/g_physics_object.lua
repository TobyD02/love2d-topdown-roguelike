local Constants = require("constants")

---@class GPhysicsObject
---@field type string
---@field x number
---@field y number
---@field width number
---@field height number
local GPhysicsObject = {}
GPhysicsObject.__index = GPhysicsObject

---@generic TPhysicsObject
---@param type string
---@param x number
---@param y number
---@param width number
---@param height number
---@return TPhysicsObject
function GPhysicsObject:new(type, x, y, width, height)
	local obj = {
		type = type,
		x = x,
		y = y,
		width = width,
		height = height,
	}

	setmetatable(obj, self)
	return obj
end

---@param self GPhysicsObject
function GPhysicsObject:draw() end

---@param self GPhysicsObject
function GPhysicsObject:drawDebug()
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

return GPhysicsObject
