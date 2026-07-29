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

local GEntity = {}
GEntity.__index = GEntity

-- Inherit from GPhysicsObject
setmetatable(GEntity, { __index = GPhysicsObject })

---@param self GEntity
---@param x number
---@param y number
---@param width number
---@param height number
---@param type string
---@return GEntity
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
	self.moveTargetX = x + directionX
	self.moveTargetY = y + directionY
end

---@return string
function GEntity:filter()
	return Constants.FILTER_SLIDE
end

---@param dt number
function GEntity:update(dt)
	-- Do nothing
end

function GEntity:draw(dt)
	-- Do nothing
end

---@param other GPhysicsObject
function GEntity:onCollision(other)
	-- Do nothing
end

return GEntity
