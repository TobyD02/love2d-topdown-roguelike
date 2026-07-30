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
		local dirX, dirY = Helpers:normalize(self.target.x - self.x, self.target.y - self.y)
		self.moveDirX, self.moveDirY = dirX, dirY
		local timeLeftOnShooter = self.shooter.shootTimer
		local timePassedOnShooter = self.shooter.maxShootTimer - self.shooter.shootTimer

		if distance < self.shooter:getRange() and self.shooter.canShoot then
			local oX, oY = self:getOrigin()
			self.shooter:shoot(oX, oY, dirX, dirY)
		elseif distance < self.moveAwayRange then
			self.velocityX = self.velocityX + (-self.moveDirX + self.separationX) * self.accel * dt
			self.velocityY = self.velocityY + (-self.moveDirY + self.separationY) * self.accel * dt
		elseif distance > self.shooter:getRange() or (timeLeftOnShooter >= 0.5 and timePassedOnShooter >= 0.5) then
			self.velocityX = self.velocityX + (self.moveDirX + self.separationX) * self.accel * dt
			self.velocityY = self.velocityY + (self.moveDirY + self.separationY) * self.accel * dt
		else
			self.moveDirX, self.moveDirY = 0, 0
			self.velocityX = self.velocityX + self.separationX * self.accel * dt
			self.velocityY = self.velocityY + self.separationY * self.accel * dt
		end
	end

	self.separationX, self.separationY = 0, 0
end

function GEnemySpitter:draw()
	love.graphics.setColor(0, 0.6, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return GEnemySpitter
