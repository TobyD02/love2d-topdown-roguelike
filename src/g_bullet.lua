local GEntity = require("src.g_entity")
local Constants = require("constants")

---@class GBullet : GEntity
---@field owner GEntity
---@field speed number
---@field dirX number
---@field dirY number
local GBullet = {}
GBullet.__index = GBullet

-- Inherit from GEntity
setmetatable(GBullet, { __index = GEntity })

---@generic TBullet
---@param self GBullet
---@param owner GEntity
---@param x number
---@param y number
---@param dirX number
---@param dirY number
---@return TBullet
function GBullet:new(owner, x, y, dirX, dirY)
	local obj = GEntity.new(self, x, y, Constants.BULLET_SIZE, Constants.BULLET_SIZE, Constants.TYPE_BULLET)

	obj.speed = 500
	obj.owner = owner

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

function GBullet:newFromOrigin(owner, originX, originY, dirX, dirY)
	local x = originX - Constants.BULLET_SIZE / 2
	local y = originY - Constants.BULLET_SIZE / 2

	obj = GBullet.new(self, owner, x, y, dirX, dirY)
	return obj
end

---@param other GPhysicsObject
function GBullet:filter(other)
	return Constants.FILTER_CROSS
end

---@param other GPhysicsObject
function GBullet:onCollision(other)
	if other.type == self.owner.type or other.type == Constants.TYPE_BULLET then
		return
	end

	self.world:removeEntity(self)
end

---@param self GBullet
---@param dt number
function GBullet:update(dt)
	self.moveTargetX = self.x + self.dirX * self.speed * dt
	self.moveTargetY = self.y + self.dirY * self.speed * dt
end

---@param self GBullet
function GBullet:draw()
	love.graphics.setColor(0.6, 0.6, 0.2)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return GBullet
