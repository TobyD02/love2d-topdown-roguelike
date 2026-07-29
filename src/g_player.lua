local GEntity = require("src.g_entity")
local GBullet = require("src.g_bullet")
local Constants = require("constants")

---@class GPlayer : GEntity
---@field health number
---@field speed number
---@field canShoot boolean
---@field shootTimer number
---@field maxShootTimer number
---@field lastDirX number
---@field lastDirY number
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
	obj.maxShootTimer = 0.02
	obj.shootTimer = obj.maxShootTimer
	obj.lastDirX = 1 -- Start with dir x as 1 so that it is normalized
	obj.lastDirY = 0
	return obj
end

---@param self GPlayer
---@param dt number
function GPlayer:update(dt)
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
	local dirNotZero = false
	if dirX ~= 0 or dirY ~= 0 then
		dirNotZero = true

		local len = math.sqrt(dirX * dirX + dirY * dirY)
		dirX = dirX / len
		dirY = dirY / len
	end

	if love.keyboard.isDown("space") and self.canShoot then
		local bulletDirX, bulletDirY = dirX, dirY
		if dirX == 0 and dirY == 0 then
			bulletDirX, bulletDirY = self.lastDirX, self.lastDirY
		end

		-- self.world:addEntity(GBullet:new(self, self.x, self.y, bulletDirX, bulletDirY))
		oX, oY = self:getOrigin()

		self.world:addEntity(GBullet:newFromOrigin(self, oX, oY, 1, 0))
		self.world:addEntity(GBullet:newFromOrigin(self, oX, oY, 1, 1))
		self.world:addEntity(GBullet:newFromOrigin(self, oX, oY, 1, -1))

		self.world:addEntity(GBullet:newFromOrigin(self, oX, oY, -1, 0))
		self.world:addEntity(GBullet:newFromOrigin(self, oX, oY, -1, 1))
		self.world:addEntity(GBullet:newFromOrigin(self, oX, oY, -1, -1))

		self.world:addEntity(GBullet:newFromOrigin(self, oX, oY, 0, 1))
		self.world:addEntity(GBullet:newFromOrigin(self, oX, oY, 0, -1))
		self.canShoot = false
	end

	if not self.canShoot then
		self.shootTimer = self.shootTimer - dt
		if self.shootTimer <= 0 then
			self.canShoot = true
			self.shootTimer = self.maxShootTimer
		end
	end

	self.moveTargetX = self.x + dirX * self.speed * dt
	self.moveTargetY = self.y + dirY * self.speed * dt

	if dirNotZero then
		self.lastDirX = dirX
		self.lastDirY = dirY
	end
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
