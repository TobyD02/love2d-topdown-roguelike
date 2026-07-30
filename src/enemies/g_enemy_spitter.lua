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
function GEnemySpitter:think(dt)
	if self.target ~= nil then
		local dirX, dirY = Helpers:normalize(self.target.x - self.x, self.target.y - self.y)
		self.moveDirX, self.moveDirY = dirX, dirY
		local timeLeftOnShooter = self.shooter.shootTimer.timeLeft
		local timePassedOnShooter = self.shooter.shootTimer.waitTime - timeLeftOnShooter

		if self.distanceFromTargetSquared < self.shooter:getRangeSquared() and self.shooter.canShoot then
			local oX, oY = self:getOrigin()
			self.shooter:shoot(oX, oY, dirX, dirY)
		elseif self.distanceFromTargetSquared < self.moveAwayRange * self.moveAwayRange then
			self.velocityX = self.velocityX + (-self.moveDirX + self.separationX) * self.accel * dt
			self.velocityY = self.velocityY + (-self.moveDirY + self.separationY) * self.accel * dt
		elseif
			self.distanceFromTargetSquared > self.shooter:getRangeSquared()
			or (timeLeftOnShooter >= 0.5 and timePassedOnShooter >= 0.5)
		then
			self.velocityX = self.velocityX + (self.moveDirX + self.separationX) * self.accel * dt
			self.velocityY = self.velocityY + (self.moveDirY + self.separationY) * self.accel * dt
		else
			self.moveDirX, self.moveDirY = 0, 0
			self.velocityX = self.velocityX + self.separationX * self.accel * dt
			self.velocityY = self.velocityY + self.separationY * self.accel * dt
		end
	end
end

function GEnemySpitter:draw()
	GEnemy.draw(self)
end

return GEnemySpitter
