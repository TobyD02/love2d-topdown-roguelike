---@class GShooter
---@field world GWorld
---@field owner GEntity
---@field bulletClass GBullet
local GShooter = {}
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
	self.world:addEntity(self.bulletClass:newFromOrigin(self.owner, originX, originY, directionX, directionY))
end

---@param self GShooter
---@param world GWorld
function GShooter:setWorld(world)
	self.world = world
end

return GShooter
