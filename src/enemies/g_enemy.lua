local GKinematicEntity = require("src.core.g_kinematic_entity")
local GTimer = require("src.core.g_timer")
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
---@field sleepRange number
---@field findTargetTimer GTimer
---@field distanceFromTargetSquared number
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
	local obj = GKinematicEntity.new(self, x, y, Constants.PLAYER_SIZE, Constants.PLAYER_SIZE, { 0.6, 0, 0 })
	obj:addTag(Tags.ENEMY)

	obj.health = 100
	obj.maxSpeed = 7
	obj.accel = 50
	obj.friction = 0.9

	obj.sleepRange = 1000

	obj.shooter = GShooter:new(obj)
	obj.canShoot = true
	obj.maxShootTimer = 0.1
	obj.shootTimer = obj.maxShootTimer
	obj.target = nil

	obj.moveDirX, obj.moveDirY = 0, 0

	obj.separationX = 0
	obj.separationY = 0

	obj.findTargetTimer = GTimer:new(0.05)

	return obj
end

---@param self GEnemy
---@param dt number
function GEnemy:update(dt)
	self.findTargetTimer:update(dt)
	self.shooter:update(dt)

	if self.findTargetTimer:isFinished() then
		if self.target == nil then
			---@type GPlayer[]
			local players = self.world:getEntitiesByTag(Tags.PLAYER)
			if #players > 0 then
				self.target = players[1]
			end
		end

		self.distanceFromTargetSquared = Helpers:distanceSquared(self.x, self.y, self.target.x, self.target.y)
		self.findTargetTimer:start()
	end

	if self.distanceFromTargetSquared <= self.sleepRange * self.sleepRange then
		self:think(dt)
	end
end

---@param self GEnemy
---@return boolean
function GEnemy:canSeeTarget()
	if self.target == nil then
		return false
	end

	local tag = Tags.WALL

	local hits = self.world:ray(self.x, self.y, self.target.x, self.target.y, tag)
	return #hits == 0
end

---@param self GEnemy
function GEnemy:draw()
	GKinematicEntity.draw(self)
end

---@param self GEnemy
---@param dt number
function GEnemy:think(dtd)
	-- Do nothing
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

	self.separationX, self.separationY = 0, 0
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
