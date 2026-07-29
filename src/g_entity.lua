local GPhysicsObject = require("src.g_physics_object")
local Constants = require("constants")

---@class GEntity : GPhysicsObject
---@field world GWorld
---@field x number
---@field y number
---@field width number
---@field height number
---@field moveTargetX number
---@field moveTargetY number
---@field queuedForDelete boolean
---@field originX number
---@field originY number
local GEntity = {}
GEntity.__index = GEntity

-- Inherit from GPhysicsObject
setmetatable(GEntity, { __index = GPhysicsObject })

---@generic TEntity
---@param self TEntity
---@param x number
---@param y number
---@param width number
---@param height number
---@param type string
---@return TEntity
function GEntity:new(x, y, width, height, type)
	local obj = GPhysicsObject.new(self, type)
	obj.world = nil
	obj.x = x
	obj.y = y
	obj.width = width
	obj.height = height
	obj.moveTargetX = x
	obj.moveTargetY = y
	obj.queuedForDelete = false

	return obj
end

---@param self GEntity
---@param directionX number
---@param directionY number
function GEntity:move(directionX, directionY)
	self.moveTargetX = self.x + directionX
	self.moveTargetY = self.y + directionY
end

---@param self GEntity
---@return string
function GEntity:filter()
	return Constants.FILTER_SLIDE
end

---@param self GEntity
---@return number
---@return number
function GEntity:getOrigin()
	return self.x + (self.width / 2), self.y + (self.height / 2)
end

---@param self GEntity
---@param dt number
function GEntity:update(dt)
	-- Do nothing
end

---@param self GEntity
function GEntity:draw()
	-- Do nothing
end

---@param self GEntity
---@param other GPhysicsObject
function GEntity:onCollision(other)
	-- Do nothing
end

return GEntity
