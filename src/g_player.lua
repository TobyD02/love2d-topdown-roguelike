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
	local obj = GKinematicEntity.new(self, x, y, Constants.PLAYER_SIZE, Constants.PLAYER_SIZE)
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
	obj.lastDirX = 1 -- Start with dir x as 1 so that it is normalized
	obj.lastDirY = 0
	return obj
end

---@param self GPlayer
---@param dt number
function GPlayer:update(dt)
	self.shooter:update(dt)

	local dirX, dirY = 0, 0

	if love.keyboard.isDown("w") then
		dirY = dirY - 1
	end

	if love.keyboard.isDown("s") then
		dirY = dirY + 1
	end

	if love.keyboard.isDown("a") then
		dirX = dirX - 1
	end

	if love.keyboard.isDown("d") then
		dirX = dirX + 1
	end

	-- Normalize diagonal movement
	dirX, dirY = Helpers:normalize(dirX, dirY)

	if dirX == 0 and dirY == 0 then
		self.velocityX = self.velocityX * self.friction
		self.velocityY = self.velocityY * self.friction
		self.velocityX, self.velocityY = Helpers:roundVecZero(self.velocityX, self.velocityY, 0.5)
	else
		self.velocityX = self.velocityX + dirX * self.accel * dt
		self.velocityY = self.velocityY + dirY * self.accel * dt
	end

	--- Shooting logic
	if love.keyboard.isDown("space") then
		local bulletDirX, bulletDirY = dirX, dirY
		if dirX == 0 and dirY == 0 then
			bulletDirX, bulletDirY = self.lastDirX, self.lastDirY
		end

		-- self.world:addEntity(GBullet:new(self, self.x, self.y, bulletDirX, bulletDirY))
		local oX, oY = self:getOrigin()
		self.shooter:shoot(oX, oY, bulletDirX, bulletDirY)
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

	love.graphics.setColor(0.9, 0.3, 0.3)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function GPlayer:setWorld(world)
	GKinematicEntity.setWorld(self, world)
	self.shooter:setWorld(world)
end

return GPlayer
