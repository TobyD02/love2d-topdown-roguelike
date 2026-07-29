local GEnemy = require("src.enemies.g_enemy")
local GShooterSpitter = require("src.shooters.g_shooter_spitter")
local Tags = require("src.tags")
local Helpers = require("src.helpers")

---@class GEnemySpitter : GEnemy
---@field moveAwayRange number
local GEnemySpitter = {}

GEnemySpitter.__index = GEnemySpitter

-- Inherit from GEnemy
setmetatable(GEnemySpitter, { __index = GEnemy })

---@generic TEnemySpitter
---@param x number
---@param y number
---@return TEnemySpitter
function GEnemySpitter:new(x, y)
	local obj = GEnemy.new(self, x, y)
	obj.shooter = GShooterSpitter:new(obj)
	obj.moveAwayRange = 100
	return obj
end

---@param self GEnemySpitter
---@param dt number
function GEnemySpitter:update(dt)
	GEnemy.update(self, dt)

	if self.target == nil then
		local players = self.world:getEntitiesByTag(Tags.PLAYER)
		if #players > 0 then
			self.target = players[1]
		end
	end

	if self.target ~= nil then
		local distance = Helpers:distance(self.x, self.y, self.target.x, self.target.y)
		local dirX, dirY = Helpers:normalize(self.target.moveTargetX - self.x, self.target.moveTargetY - self.y)

		if distance < self.shooter:getRange() and self.shooter.canShoot then
			local oX, oY = self:getOrigin()
			self.shooter:shoot(oX, oY, dirX, dirY)
		elseif
			Helpers:distance(self.x, self.y, self.target.moveTargetX, self.target.moveTargetY) < self.moveAwayRange
		then
			self.moveTargetX = self.x + (-dirX + self.separationX) * self.speed * dt
			self.moveTargetY = self.y + (-dirY + self.separationY) * self.speed * dt
		elseif self.shooter.shootTimer <= self.shooter.maxShootTimer - 0.5 then
			self.moveTargetX = self.x + (dirX + self.separationX) * self.speed * dt
			self.moveTargetY = self.y + (dirY + self.separationY) * self.speed * dt
		end
	end

	self.separationX, self.separationY = 0, 0
end

return GEnemySpitter
