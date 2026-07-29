local Constants = require("constants")

---@class GWorld
---@field cellSize number
---@field width number
---@field height number
---@field entities GEntity[]
---@field entityIndexMap table<GEntity, number>
---@field entityRemoveQueue GEntity[]
---@field walls GWall[]
---@field bumpWorld bump.World
local GWorld = {}
GWorld.__index = GWorld

---@param width number
---@param height number
---@param cellSize number
function GWorld:new(width, height, cellSize)
	local obj = {
		cellSize = cellSize,
		width = width,
		height = height,
		walls = {},
		entities = {},
		entityIndexMap = {},
		entityRemoveQueue = {},
		bumpWorld = require("lib.bump.bump").newWorld(cellSize),
	}

	setmetatable(obj, GWorld)
	return obj
end

---@param self GWorld
---@param wall GWall
function GWorld:addWall(wall)
	table.insert(self.walls, wall)
	self.bumpWorld:add(wall, wall.x, wall.y, wall.width, wall.height)
end

---@param self GWorld
---@param walls GWall[]
function GWorld:addWalls(walls)
	for _, wall in ipairs(walls) do
		table.insert(self.walls, wall)
		self.bumpWorld:add(wall, wall.x, wall.y, wall.width, wall.height)
	end
end

---@param self GWorld
---@param entity GEntity
function GWorld:addEntity(entity)
	entity:setWorld(self)

	table.insert(self.entities, entity)
	self.entityIndexMap[entity] = #self.entities

	self.bumpWorld:add(entity, entity.x, entity.y, entity.width, entity.height)
end

---@param self GWorld
---@param entity GEntity
function GWorld:removeEntity(entity)
	if entity.queuedForDelete then
		return
	end
	table.insert(self.entityRemoveQueue, entity)
	entity.queuedForDelete = true
end

function GWorld:processEntityRemoveQueue()
	for _, entity in ipairs(self.entityRemoveQueue) do
		local index = self.entityIndexMap[entity]

		if index then
			local lastIndex = #self.entities
			local lastEntity = self.entities[lastIndex]

			self.entities[index] = lastEntity
			self.entityIndexMap[lastEntity] = index

			self.entities[lastIndex] = nil
			self.entityIndexMap[entity] = nil
		end

		self.bumpWorld:remove(entity)
	end

	self.entityRemoveQueue = {}
end

---@param self GWorld
---@param dt number
function GWorld:update(dt)
	local function collisionFilter(item, other)
		return item:filter(other)
	end

	for _, entity in ipairs(self.entities) do
		---@type GEntity
		if entity.queuedForDelete then
			goto continue
		end

		entity:update(dt)

		local count = 0
		local collisions = {}

		if entity.x ~= entity.moveTargetX or entity.y ~= entity.moveTargetY then
			_, _, collisions, count =
				self.bumpWorld:move(entity, entity.moveTargetX, entity.moveTargetY, collisionFilter)
		end

		for i = 1, count do
			local collision = collisions[i]
			entity:onCollision(collision.other)
		end

		entity.x, entity.y = self.bumpWorld:getRect(entity)

		::continue::
	end

	self:processEntityRemoveQueue()
end

function GWorld:draw()
	for _, wall in ipairs(self.walls) do
		wall:draw()
	end

	for _, entity in ipairs(self.entities) do
		entity:draw()
	end

	if Constants.DEBUG then
		for _, wall in ipairs(self.walls) do
			wall:drawDebug()
		end

		for _, entity in ipairs(self.entities) do
			entity:drawDebug()
		end
		
	end
end

return GWorld
