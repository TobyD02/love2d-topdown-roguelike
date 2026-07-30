local GKinematicEntity = require("src.core.g_kinematic_entity")
local Constants = require("src.constants")
local GShooter = require("src.shooters.g_shooter")
local Tags = require("src.tags")
local Helpers = require("src.helpers")

---@class GPlayer : GKinematicEntity
---@field health number
---@field canShoot boolean
---@field shootTimer number
---@field maxShootTimer number
---@field lastDirX number
---@field lastDirY number
---@field shooter GShooter
local GPlayer = {}
GPlayer.__index = GPlayer

-- Inherit from GKinematicEntity
setmetatable(GPlayer, { __index = GKinematicEntity })

---@generic TPlayer
---@param x number
---@param y number
---@param shooter GShooter|nil
---@return TPlayer
function GPlayer:new(x, y, shooter)
	---@type GPlayer
	local obj = GKinematicEntity.new(self, x, y, Constants.PLAYER_SIZE, Constants.PLAYER_SIZE, { 0, 0.5, 0 })
	obj:addTag(Tags.PLAYER)

	obj.health = 100
	obj.accel = 50
	obj.maxSpeed = 10
	obj.friction = 0.9

	obj.velocityX, obj.velocityY = 0, 0

	if shooter == nil then
		shooter = GShooter:new(obj)
	end

	obj.shooter = shooter
	obj.canShoot = true
	obj.maxShootTimer = 0.1
	obj.shootTimer = obj.maxShootTimer
	obj.lastDirX = 1 -- Start with moveDir x as 1 so that it is normalized
	obj.lastDirY = 0
	return obj
end

---@param self GPlayer
---@param dt number
function GPlayer:update(dt)
	self.shooter:update(dt)

	local moveDirX, moveDirY = 0, 0
	local shootDirX, shootDirY = 0, 0

	moveDirY = love.keyboard.isDown("s") and moveDirY + 1 or moveDirY
	moveDirY = love.keyboard.isDown("w") and moveDirY - 1 or moveDirY

	moveDirX = love.keyboard.isDown("d") and moveDirX + 1 or moveDirX
	moveDirX = love.keyboard.isDown("a") and moveDirX - 1 or moveDirX

	shootDirY = love.keyboard.isDown("down") and shootDirY + 1 or shootDirY
	shootDirY = love.keyboard.isDown("up") and shootDirY - 1 or shootDirY

	shootDirX = love.keyboard.isDown("right") and shootDirX + 1 or shootDirX
	shootDirX = love.keyboard.isDown("left") and shootDirX - 1 or shootDirX

	-- Normalize diagonal movement
	moveDirX, moveDirY = Helpers:normalize(moveDirX, moveDirY)

	if moveDirX == 0 and moveDirY == 0 then
		self.velocityX = self.velocityX * self.friction
		self.velocityY = self.velocityY * self.friction
		self.velocityX, self.velocityY = Helpers:roundVecZero(self.velocityX, self.velocityY, 0.5)
	else
		self.velocityX = self.velocityX + moveDirX * self.accel * dt
		self.velocityY = self.velocityY + moveDirY * self.accel * dt
	end

	--- Shooting logic
	if Helpers:distanceSquared(0, 0, shootDirX, shootDirY) > 0 then
		local oX, oY = self:getOrigin()
		self.shooter:shoot(oX, oY, shootDirX, shootDirY)
	end
end

---@param self GPlayer
---@param other GPhysicsObject
function GPlayer:filter(other)
	if other:hasTag(Tags.BULLET) then
		return Constants.FILTER_CROSS
	else
		return Constants.FILTER_SLIDE
	end
end

---@param self GPlayer
---@param other GPhysicsObject
function GPlayer:onCollision(other)
	if other:hasTag(Tags.ENEMY) then
		return Constants.FILTER_TOUCH
	end

	return Constants.FILTER_SLIDE
end

---@param self GPlayer
function GPlayer:draw()
	GKinematicEntity.draw(self) -- Call parent draw function first
end

function GPlayer:setWorld(world)
	GKinematicEntity.setWorld(self, world)
	self.shooter:setWorld(world)
end

return GPlayer
