local GEntity = require("src.g_entity")
local GBullet = require("src.g_bullet")
local Constants = require("constants")

---@class GPlayer : GEntity
---@field health number
---@field speed number
---@field canShoot boolean
---@field shootTimer number
---@field maxShootTimer number
local GPlayer = {}
GPlayer.__index = GPlayer

-- Inherit from GEntity
setmetatable(GPlayer, { __index = GEntity })

---@param x number
---@param y number
---@param width number
---@param height number
---@return GPlayer
function GPlayer:new(x, y)
	local obj = GEntity.new(self, x, y, Constants.PLAYER_SIZE, Constants.PLAYER_SIZE, Constants.TYPE_PLAYER)
	obj.health = 100
	obj.speed = 200
	obj.canShoot = true
	obj.shootTimer, obj.maxShootTimer = 0.5, 0.5
	return obj
end

---@param self GPlayer
---@param dt number
function GPlayer:update(dt)
	local dx, dy = 0, 0

	if love.keyboard.isDown("w") then
		dy = dy - 1
	end

	if love.keyboard.isDown("s") then
		dy = dy + 1
	end

	if love.keyboard.isDown("a") then
		dx = dx - 1
	end

	if love.keyboard.isDown("d") then
		dx = dx + 1
	end

	-- Normalize diagonal movement
	if dx ~= 0 or dy ~= 0 then
		local len = math.sqrt(dx * dx + dy * dy)
		dx = dx / len
		dy = dy / len
	end

	if love.keyboard.isDown("space") and self.canShoot then
		self.world:addEntity(GBullet:new(self, self.x, self.y, dx, dy))
		self.canShoot = false
	end

	if not self.canShoot then
		self.shootTimer = self.shootTimer - dt
		if self.shootTimer <= 0 then
			self.canShoot = true
			self.shootTimer = self.maxShootTimer
		end
	end

	self.moveTargetX = self.x + dx * self.speed * dt
	self.moveTargetY = self.y + dy * self.speed * dt
end

---@param other GPhysicsObject
function GPlayer:filter(other)
	if other.type == Constants.TYPE_BULLET then
		return Constants.FILTER_CROSS
	else
		return Constants.FILTER_SLIDE
	end
end

---@param self GPlayer
function GPlayer:draw()
	love.graphics.setColor(0.9, 0.3, 0.3)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return GPlayer
