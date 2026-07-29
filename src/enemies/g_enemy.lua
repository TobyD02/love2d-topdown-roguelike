local GEntity = require("src.g_entity")
local Constants = require("src.constants")
local GShooter = require("src.shooters.g_shooter")
local Tags = require("src.tags")
local Helpers = require("src.helpers")

---@class GEnemy : GEntity
---@field health number
---@field speed number
---@field canShoot boolean
---@field shootTimer number
---@field maxShootTimer number
---@field shooter GShooter
---@field target GEntity|nil
---@field separationX number
---@field separationY number
local GEnemy = {}
GEnemy.__index = GEnemy

-- Inherit from GEntity
setmetatable(GEnemy, { __index = GEntity })

---@generic TEnemy
---@param x number
---@param y number
---@return TEnemy
function GEnemy:new(x, y)
	---@type GEnemy
	local obj = GEntity.new(self, x, y, Constants.PLAYER_SIZE, Constants.PLAYER_SIZE)
	obj:addTag(Tags.ENEMY)

	obj.health = 100
	obj.speed = 100

	obj.shooter = GShooter:new(obj)
	obj.canShoot = true
	obj.maxShootTimer = 0.1
	obj.shootTimer = obj.maxShootTimer
	obj.target = nil

	obj.separationX = 0
	obj.separationY = 0

	return obj
end

---@param self GEnemy
---@param dt number
function GEnemy:update(dt)
	self.shooter:update(dt)

	if self.target == nil then
		local players = self.world:getEntitiesByTag(Tags.PLAYER)
		if #players > 0 then
			self.target = players[1]
		end
	end
end

---@param self GEnemy
---@param other GPhysicsObject
function GEnemy:filter(other)
	if other:hasTag(Tags.ENEMY) then
		return Constants.FILTER_CROSS
	end

	if other:hasTag(Tags.BULLET) then
		---@type GBullet
		local b = other
		if b.owner == self then
			return Constants.FILTER_CROSS
		end
	end

	return Constants.FILTER_SLIDE
end

---@param self GEnemy
---@param other GPhysicsObject
function GEnemy:onCollision(other)
	if other:hasTag(Tags.ENEMY) then
		local sepX = self.x - other.x
		local sepY = self.y - other.y

		self.separationX, self.separationY = Helpers:normalize(sepX, sepY)
	end
end

---@param self GEnemy
---@param world GWorld
function GEnemy:setWorld(world)
	self.world = world
	self.shooter:setWorld(world)
end

return GEnemy
