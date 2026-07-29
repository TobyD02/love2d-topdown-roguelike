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
---@param shooter GShooter|nil
---@return TEnemy
function GEnemy:new(x, y, shooter)
	---@type GEnemy
	local obj = GEntity.new(self, x, y, Constants.PLAYER_SIZE, Constants.PLAYER_SIZE)
	obj:addTag(Tags.ENEMY)

	obj.health = 100
	obj.speed = 100

	if shooter == nil then
		shooter = GShooter:new(obj)
	end

	obj.shooter = shooter
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
	if self.target == nil then
		local players = self.world:getEntitiesByTag(Tags.PLAYER)
		if #players > 0 then
			self.target = players[1]
		end
	end

	if self.target ~= nil then
		local dirX = self.target.x - self.x
		local dirY = self.target.y - self.y

		dirX, dirY = Helpers:normalize(dirX, dirY)

		self.moveTargetX = self.x + (dirX + self.separationX) * self.speed * dt
		self.moveTargetY = self.y + (dirY + self.separationY) * self.speed * dt
	end

	self.separationX, self.separationY = 0, 0
end

---@param self GEnemy
---@param other GPhysicsObject
function GEnemy:filter(other)
	if other:hasTag(Tags.ENEMY) then
		return Constants.FILTER_CROSS
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

return GEnemy
