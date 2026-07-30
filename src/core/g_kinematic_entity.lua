local GEntity = require("src.core.g_entity")
local Tags = require("src.tags")
local Helpers = require("src.helpers")

---@class GKinematicEntity : GEntity
---@field accel number
---@field friction number
---@field maxSpeed number
local GKinematicEntity = {}
GKinematicEntity.__index = GKinematicEntity

-- Inherit from GEntity
setmetatable(GKinematicEntity, { __index = GEntity })

---@generic TKinematicEntity:GKinematicEntity
---@param self TKinematicEntity
---@param x number
---@param y number
---@param width number
---@param height number
---@param color table<number, number, number> | nil
---@return TKinematicEntity
function GKinematicEntity:new(x, y, width, height, color)
	local obj = GEntity.new(self, x, y, width, height, color)
	obj:addTag(Tags.KINEMATIC_ENTITY)

	obj.accel = 50
	obj.maxSpeed = 10
	obj.friction = 0.9

	obj.velocityX, obj.velocityY = 0, 0
	return obj
end

---@param self GKinematicEntity
---@param dt number
function GKinematicEntity:postUpdate(dt)
	self.velocityX, self.velocityY = Helpers:clampVec(self.velocityX, self.velocityY, self.maxSpeed)
end

function GKinematicEntity:setWorld(world)
	GEntity.setWorld(self, world)
end

return GKinematicEntity
