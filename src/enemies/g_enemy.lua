local GKinematicEntity = require("src.core.g_kinematic_entity")
local Constants = require("src.constants")
local GShooter = require("src.shooters.g_shooter")
local Tags = require("src.tags")
local Helpers = require("src.helpers")

---@class GEnemy : GKinematicEntity
---@field health number
---@field canShoot boolean
---@field shootTimer number
---@field maxShootTimer number
---@field shooter GShooter
---@field target GKinematicEntity|nil
---@field separationX number
---@field separationY number
---@field moveDirX number
---@field moveDirY number
local GEnemy = {}
GEnemy.__index = GEnemy

-- Inherit from GKinematicEntity
setmetatable(GEnemy, { __index = GKinematicEntity })

---@generic TEnemy
---@param x number
---@param y number
---@return TEnemy
function GEnemy:new(x, y)
	---@type GEnemy
	local obj = GKinematicEntity.new(self, x, y, Constants.PLAYER_SIZE, Constants.PLAYER_SIZE)
	obj:addTag(Tags.ENEMY)

	obj.health = 100
	obj.maxSpeed = 7
	obj.accel = 50
	obj.friction = 0.9

	obj.shooter = GShooter:new(obj)
	obj.canShoot = true
	obj.maxShootTimer = 0.1
	obj.shootTimer = obj.maxShootTimer
	obj.target = nil

	obj.moveDirX, obj.moveDirY = 0, 0

	obj.separationX = 0
	obj.separationY = 0

	return obj
end

---@param self GEnemy
---@param dt number
function GEnemy:update(dt)
	self.shooter:update(dt)

	if self.target == nil then
		---@type GPlayer[]
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
		if Helpers:isMapEqual(b.owner.tags, self.tags) then
			return Constants.FILTER_CROSS
		end
	end

	return Constants.FILTER_SLIDE
end

function GEnemy:preUpdate(dt)
	self.moveDirX, self.moveDirY = 0, 0
end

function GEnemy:postUpdate(dt)
	GKinematicEntity.postUpdate(self, dt)
	if self.moveDirX == 0 and self.moveDirY == 0 then
		self.velocityX = self.velocityX * self.friction
		self.velocityY = self.velocityY * self.friction
		self.velocityX, self.velocityY = Helpers:roundVecZero(self.velocityX, self.velocityY)
	end
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
