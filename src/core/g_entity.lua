local GPhysicsObject = require("src.core.g_physics_object")
local Constants = require("src.constants")
local Helpers = require("src.helpers")
local Tags = require("src.tags")

---@class GEntity : GPhysicsObject
---@field world GWorld
---@field velocityX number
---@field velocityY number
---@field queuedForDelete boolean
---@field originX number
---@field originY number
local GEntity = {}
GEntity.__index = GEntity

-- Inherit from GPhysicsObject
setmetatable(GEntity, { __index = GPhysicsObject })

---@generic TEntity : GEntity
---@param self TEntity
---@param x number
---@param y number
---@param width number
---@param height number
---@return TEntity
function GEntity:new(x, y, width, height)
	local obj = GPhysicsObject.new(self, x, y, width, height)
	obj:addTag(Tags.ENTITY)

	obj.world = nil
	obj.x = x
	obj.y = y
	obj.width = width
	obj.height = height
	obj.velocityX = x
	obj.velocityY = y
	obj.queuedForDelete = false

	return obj
end

---@param self GEntity
---@param directionX number
---@param directionY number
function GEntity:move(directionX, directionY)
	self.velocityX = self.velocityX + directionX
	self.velocityY = self.velocityY + directionY
end

---@param self GEntity
---@param other GPhysicsObject
---@return string
--- Accepts GPhysicsObject other, and returns one of:
---		- Constants.FILTER_SLIDE = Collide and move other
---		- Constants.FILTER_TOUCH = Collide but dont move other
---		- Constants.FILTER_CROSS = Pass through
function GEntity:filter(other)
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
function GEntity:preUpdate(dt)
	-- Do nothing
end

---@param self GEntity
---@param dt number
function GEntity:update(dt)
	-- Do nothing
end

---@param self GEntity
---@param dt number
function GEntity:postUpdate(dt)
	-- Do nothing
end

---@param self GEntity
function GEntity:draw()
	GPhysicsObject.draw(self) -- Call parent draw
end

---@param self GEntity
---@param other GPhysicsObject
function GEntity:onCollision(other)
	-- Do nothing
end

---@param self GEntity
---@param world GWorld
function GEntity:setWorld(world)
	self.world = world
end

return GEntity
