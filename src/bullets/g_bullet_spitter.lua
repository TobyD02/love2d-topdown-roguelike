local GBullet = require("src.bullets.g_bullet")
local Constants = require("src.constants")
local Tags = require("src.tags")

---@class GBulletSpitter : GBullet
---@field owner GEntity
---@field speed number
---@field dirX number
---@field dirY number
local GBulletSpitter = {}
GBulletSpitter.__index = GBulletSpitter

-- Inherit from GEntity
setmetatable(GBulletSpitter, { __index = GBullet })

---@generic TBulletSpitter
---@param self GBulletSpitter
---@param owner GEntity
---@param x number
---@param y number
---@param dirX number
---@param dirY number
---@param range number
---@return TBulletSpitter
function GBulletSpitter:new(owner, x, y, dirX, dirY, range)
	---@type GBulletSpitter
	local obj = GBullet.new(self, owner, x, y, dirX, dirY, range)
	return obj
end

---@param self GBulletSpitter
---@param dt number
function GBulletSpitter:update(dt)
	GBullet.update(self, dt)
end

---@param self GBulletSpitter
function GBulletSpitter:draw()
	GBullet.draw(self) -- Call parent draw function first

	love.graphics.setColor(0.6, 0.6, 0.2)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return GBulletSpitter
