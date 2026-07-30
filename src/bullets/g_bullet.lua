local GKinematicEntity = require("src.core.g_kinematic_entity")
local Constants = require("src.constants")
local Tags = require("src.tags")
local Helpers = require("src.helpers")

---@class GBullet : GKinematicEntity
---@field owner GEntity
---@field dirX number
---@field dirY number
---@field range number
---@field startX number
---@field startY number
local GBullet = {}
GBullet.__index = GBullet

-- Inherit from GKinematicEntity
setmetatable(GBullet, { __index = GKinematicEntity })

---@generic TBullet
---@param self GBullet
---@param owner GEntity
---@param x number
---@param y number
---@param dirX number
---@param dirY number
---@param range number
---@return TBullet
function GBullet:new(owner, x, y, dirX, dirY, range)
	---@type GBullet
	local obj = GKinematicEntity.new(self, x, y, Constants.BULLET_SIZE, Constants.BULLET_SIZE)
	obj:addTag(Tags.BULLET)

	obj.startX = x
	obj.startY = y

	obj.maxSpeed = 1000
	obj.owner = owner

	if range == nil then
		range = 100
	end

	obj.range = range

	-- Normalize direction
	if dirX ~= 0 or dirY ~= 0 then
		local len = math.sqrt(dirX * dirX + dirY * dirY)
		dirX = dirX / len
		dirY = dirY / len
	end

	obj.dirX = dirX
	obj.dirY = dirY

	return obj
end

---@param self GBullet
---@param owner GEntity
---@param originX number
---@param originY number
---@param dirX number
---@param dirY number
---@param range number
function GBullet:newFromOrigin(owner, originX, originY, dirX, dirY, range)
	local x = originX - Constants.BULLET_SIZE / 2
	local y = originY - Constants.BULLET_SIZE / 2

	local obj = GBullet.new(self, owner, x, y, dirX, dirY, range)
	return obj
end

---@param self GBullet
---@param other GPhysicsObject
function GBullet:filter(other)
	return Constants.FILTER_CROSS
end

---@param other GPhysicsObject
function GBullet:onCollision(other)
	if Helpers:isMapEqual(other.tags, self.owner.tags) or other:hasTag(Tags.BULLET) then
		return
	end

	self.world:removeEntity(self)
end

---@param self GBullet
---@param dt number
function GBullet:update(dt)
	local distance = Helpers:distance(self.startX, self.startY, self.x, self.y)
	if distance >= self.range then
		self.world:removeEntity(self)
		return
	end

	self.velocityX = self.dirX * self.maxSpeed * dt
	self.velocityY = self.dirY * self.maxSpeed * dt
end

---@param self GBullet
function GBullet:draw()
	GKinematicEntity.draw(self) -- Call parent draw function first
end

return GBullet
