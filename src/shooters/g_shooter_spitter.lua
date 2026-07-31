local GShooter = require("src.shooters.g_shooter")
local Helpers = require("src.helpers")
local GTimer = require("src.core.g_timer")
---@class GShooterSpitter : GShooter
---@field world GWorld
---@field owner GEntity
---@field spread number
---@field bulletClass GBullet
local GShooterSpitter = {
	range = 600,
}
GShooterSpitter.__index = GShooterSpitter

-- Inherit from GShooter
setmetatable(GShooterSpitter, { __index = GShooter })

---@generic TShooterSpitter
---@param owner GEntity
---@return TShooterSpitter
function GShooterSpitter:new(owner)
	local bulletClass = require("src.bullets.g_bullet_spitter")
	local obj = GShooter.new(self, owner, bulletClass)

	obj.spread = 10
	obj.shootTimer = GTimer:new(2 + math.random() * 3, true)
	setmetatable(obj, self)
	return obj
end

---@param self GShooterSpitter
---@param originX number
---@param originY number
---@param directionX number
---@param directionY number
function GShooterSpitter:shoot(originX, originY, directionX, directionY)
	if self.canShoot then
		for _, angle in ipairs({ -self.spread, 0, self.spread }) do
			local dirX, dirY = Helpers:rotateVecByAngleDegrees(directionX, directionY, angle)
			self.world:addEntity(
				self.bulletClass:newFromOrigin(self.owner, originX, originY, dirX, dirY, self.range, self.bulletColor)
			)
		end
		self.canShoot = false
	end
end

return GShooterSpitter
