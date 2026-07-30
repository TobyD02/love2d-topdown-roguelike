local GTimer = require("src.core.g_timer")

---@class GShooter
---@field world GWorld
---@field owner GEntity
---@field bulletClass GBullet
---@field canShoot boolean
---@field shootTimer GTimer
---@field range number
---@field shootStartX number
---@field shootStartY number
local GShooter = {
	range = 100,
}
GShooter.__index = GShooter

---@generic TShooter
---@param owner GEntity
---@param bulletClass GBullet|nil
---@return TShooter
function GShooter:new(owner, bulletClass)
	if bulletClass == nil then
		bulletClass = require("src.bullets.g_bullet")
	end

	local obj = {
		owner = owner,
		bulletClass = bulletClass,
		canShoot = true,
		shootTimer = GTimer:new(3),
		shootStartX = owner.x,
		shootStartY = owner.y,
	}

	setmetatable(obj, self)
	return obj
end

---@param self GShooter
---@param originX number
---@param originY number
---@param directionX number
---@param directionY number
function GShooter:shoot(originX, originY, directionX, directionY)
	if self.canShoot then
		self.world:addEntity(
			self.bulletClass:newFromOrigin(self.owner, originX, originY, directionX, directionY, self.range)
		)
		self.canShoot = false
	end
end

---@param self GShooter
---@param dt number
function GShooter:update(dt)
	self.shootTimer:update(dt)

	if self.shootTimer:isFinished() then
		self.canShoot = true
		self.shootTimer:start()
	end
end

---@param self GShooter
---@param world GWorld
function GShooter:setWorld(world)
	self.world = world
end

---@param self GShooter
function GShooter:getRange()
	if self.range == nil then
		error("Shooter should declare range statically")
	end
	return self.range
end

return GShooter
