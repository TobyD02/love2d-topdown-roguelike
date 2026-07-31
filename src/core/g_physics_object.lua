local Tags = require("src.tags")
local Constants = require("src.constants")

---@class GPhysicsObject
---@field tags table<string, boolean>
---@field x number
---@field y number
---@field width number
---@field height number
---@field color table<number, number, number>
---@field frameCollisions table<GPhysicsObject, boolean>
local GPhysicsObject = {}
GPhysicsObject.__index = GPhysicsObject

---@generic TPhysicsObject: GPhysicsObject
---@param self TPhysicsObject
---@param x number
---@param y number
---@param width number
---@param height number
---@param color table<number, number, number>|nil
---@return TPhysicsObject
function GPhysicsObject:new(x, y, width, height, color)
	local tags = {}

	for _, tag in pairs(Tags) do
		tags[tag] = false
	end

	tags[Tags.PHYSICS_OBJECT] = true

	if color == nil then
		color = { math.random(), math.random(), math.random() }
	end

	local obj = {
		tags = tags,
		x = x,
		y = y,
		width = width,
		height = height,
		color = color,
		frameCollisions = {},
	}

	setmetatable(obj, self)
	return obj
end

---@param self GPhysicsObject
function GPhysicsObject:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

---@param self GPhysicsObject
function GPhysicsObject:drawDebug()
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

---@param self GPhysicsObject
---@param tag string
function GPhysicsObject:hasTag(tag)
	local hasTag = self.tags[tag]
	if hasTag == nil then
		return false
	end
	return hasTag
end

---@param self GPhysicsObject
---@param tag string
function GPhysicsObject:addTag(tag)
	if not self.tags then
		error("Cannot add tags before initialised")
	end

	if not tag then
		error("Cannot add nil tag")
	end
	self.tags[tag] = true
end

---@param self GPhysicsObject
---@param other GPhysicsObject
function GPhysicsObject:addCollision(other)
	self.frameCollisions[other] = true
end

---@param self GPhysicsObject
---@param other GPhysicsObject
---@return string
--- Accepts GPhysicsObject other, and returns one of:
---		- Constants.FILTER_SLIDE = Collide and move other
---		- Constants.FILTER_TOUCH = Collide but dont move other
---		- Constants.FILTER_CROSS = Pass through
function GPhysicsObject:filter(other)
	return Constants.FILTER_TOUCH
end

---@param self GPhysicsObject
---@param world GWorld
function GPhysicsObject:setWorld(world)
	self.world = world
end

---@param self GPhysicsObject
---@param dt number
function GPhysicsObject:processCollisions(dt)
	-- Do nothing
	for other, _ in pairs(self.frameCollisions) do
		self:onCollision(other)
		self.frameCollisions[other] = nil
	end
end

---@param self GPhysicsObject
---@param other GPhysicsObject
function GPhysicsObject:onCollision(other)
	--- Do nothing
end

return GPhysicsObject
