local GPhysicsObject = require("src.g_physics_object")
local Constants = require("constants")

---@class GWall : GPhysicsObject
---@field x number
---@field y number
---@field width number
---@field height number
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
	local obj = GPhysicsObject.new(self, Constants.TYPE_WALL)
	obj.x = x
	obj.y = y
	obj.width = width
	obj.height = height
	return obj
end

return GWall
