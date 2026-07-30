local Constants = require("src.constants")
local Tags = require("src.tags")
local GCamera = require("src.core.g_camera")

---@class GWorld
---@field cellSize number
---@field width number
---@field height number
---@field entities GEntity[]
---@field entityIndexMap table<GEntity, number>
---@field entityRemoveQueue GEntity[]
---@field entityTagsMap table<string, GEntity>
---@field entityTagIndexMap table<string, table<GEntity, number>>
---@field walls GWall[]
---@field bumpWorld bump.World
---@field camera GCamera 
---@field lastEntityIndexProcessed number
local GWorld = {}
GWorld.__index = GWorld

---@param width number
---@param height number
---@param cellSize number
function GWorld:new(width, height, cellSize)

	local entityTagsMap = {}
	local entityTagIndexMap = {}

	for _, tag in pairs(Tags) do
		entityTagsMap[tag] = {}
		entityTagIndexMap[tag] = {}
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
		entityTagIndexMap = entityTagIndexMap,
		bumpWorld = require("lib.bump.bump").newWorld(cellSize),
		camera = GCamera:new(),
		lastEntityIndexProcessed = 1
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
	if #self.entities >= Constants.ENTITY_LIMIT then
		return
	end
	entity:setWorld(self)

	table.insert(self.entities, entity)
	self.entityIndexMap[entity] = #self.entities

	for _, tag in pairs(Tags) do
		if entity:hasTag(tag) then
			local entities = self.entityTagsMap[tag]
			local indexes = self.entityTagIndexMap[tag]

			table.insert(entities, entity)
			indexes[entity] = #entities
			end
	end

	--Helpers:printTable(self.entityTagsMap)

	self.bumpWorld:add(entity, entity.x, entity.y, entity.width, entity.height)
end

---@param self GWorld
---@param target GEntity
function GWorld:setCameraTarget(target)
	self.camera.target = target
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

---@param self GWorld
function GWorld:processEntityRemoveQueue()
	local processed = 0
	local budget = Constants.REMOVE_QUEUE_BUDGET

	while processed < budget and #self.entityRemoveQueue > 0 do
		local entity = self.entityRemoveQueue[#self.entityRemoveQueue]

		-- Remove from queue immediately
		self.entityRemoveQueue[#self.entityRemoveQueue] = nil

		self:removeEntityFromTagMap(entity)

		local index = self.entityIndexMap[entity]

		if self.camera.target == entity then
			self.camera.target = nil
		end

		if index then
			local lastIndex = #self.entities
			local lastEntity = self.entities[lastIndex]

			self.entities[index] = lastEntity
			self.entityIndexMap[lastEntity] = index

			self.entities[lastIndex] = nil
			self.entityIndexMap[entity] = nil
		end

		self.bumpWorld:remove(entity)

		processed = processed + 1
	end
end

---@param self GWorld
---@param entity GEntity
function GWorld:removeEntityFromTagMap(entity)

    for _, tag in pairs(Tags) do
        if entity:hasTag(tag) then

            local entities = self.entityTagsMap[tag]
            local indexes = self.entityTagIndexMap[tag]

            local index = indexes[entity]

            if index then
                local lastIndex = #entities
                local lastEntity = entities[lastIndex]

                entities[index] = lastEntity
                indexes[lastEntity] = index

                entities[lastIndex] = nil
            end

			indexes[entity] = nil
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

local function collisionFilter(item, other)
	return item:filter(other)
end

---@param self GWorld
---@param dt number
function GWorld:update(dt)
	if dt > 0.1 then
		print("BAD FRAME DT: ", dt)
	end

	dt = math.min(dt, 1/30)


	local collisions = {}
	local count = 0

	for _, entity in ipairs(self.entities) do
		-- for k in pairs(collisions) do
		-- 	collisions[k] = nil
		-- end

		count = 0

		---@type GEntity
		if entity.queuedForDelete then
			goto continue
		end

		entity:preUpdate(dt)
		entity:update(dt)
		entity:postUpdate(dt)


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
	
	self.camera:update(dt)
	self:processEntityRemoveQueue()
end

function GWorld:draw()
	self.camera:draw(function()
		for _, wall in ipairs(self.walls) do
			wall:draw()
		end

		for _, entity in ipairs(self.entities) do
			if entity.queuedForDelete then
				goto continue
			end
			entity:draw()
		end

		::continue::

		if Constants.DEBUG then
			for _, wall in ipairs(self.walls) do
				wall:drawDebug()
			end

			for _, entity in ipairs(self.entities) do
				entity:drawDebug()
			end
			
		end
	end)
end



return GWorld
