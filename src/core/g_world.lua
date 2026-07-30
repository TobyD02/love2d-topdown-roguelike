local Constants = require("src.constants")
local Tags = require("src.tags")
local Helpers = require("src.helpers")

---@class GWorld
---@field cellSize number
---@field width number
---@field height number
---@field entities GEntity[]
---@field entityIndexMap table<GEntity, number>
---@field entityRemoveQueue GEntity[]
---@field entityTagsMap table<string, GEntity>
---@field walls GWall[]
---@field bumpWorld bump.World
local GWorld = {}
GWorld.__index = GWorld

---@param width number
---@param height number
---@param cellSize number
function GWorld:new(width, height, cellSize)

	local entityTagsMap = {}
	for _, tag in pairs(Tags) do
		entityTagsMap[tag] = {}
	end

	local obj = {
		cellSize = cellSize,
		width = width,
		height = height,
		walls = {},
		entities = {},
		entityIndexMap = {},
		entityRemoveQueue = {},
		entityTagsMap = entityTagsMap,
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

	for _, tag in pairs(Tags) do
		if entity:hasTag(tag) then
			table.insert(self.entityTagsMap[tag], entity)
		end
	end

	--Helpers:printTable(self.entityTagsMap)

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

		self:removeEntityFromTagMap(entity)

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
---@param entity GEntity
function GWorld:removeEntityFromTagMap(entity)
	for _, tag in pairs(Tags) do
		if entity:hasTag(tag) then
			local entities = self.entityTagsMap[tag]

			if entities then
				for i, taggedEntity in ipairs(entities) do
					if taggedEntity == entity then
						table.remove(entities, i)
						break
					end
				end
			end
		end
	end
end

---@param self GWorld
---@param tag string
---@return GEntity[]
function GWorld:getEntitiesByTag(tag)
	local entities = self.entityTagsMap[tag]
	if entities == nil then
		return {}
	end

	return entities
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

		entity:preUpdate(dt)
		entity:update(dt)
		entity:postUpdate(dt)

		local count = 0
		local collisions = {}

		if entity.velocityX ~= 0 or entity.velocityY ~= 0 then
			_, _, collisions, count =
				self.bumpWorld:move(entity, entity.x + entity.velocityX, entity.y + entity.velocityY, collisionFilter)
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
