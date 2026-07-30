local Tags = require("src.tags")
local Helpers = require("src.helpers")

---@class GPhysicsObject
---@field tags table<string, boolean>
---@field x number
---@field y number
---@field width number
---@field height number
---@field color table<number, number, number>
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

return GPhysicsObject
