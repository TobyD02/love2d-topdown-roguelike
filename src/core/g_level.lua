local GWorld = require("src.core.g_world")
local GWall = require("src.core.g_wall")
local Constants = require("src.constants")
---@class GLevel
---@field world GWorld
local GLevel = {}
GLevel.__index = GLevel

---@param levelWidth number
---@param levelHeight number
function GLevel:new(levelWidth, levelHeight)
	local obj = {
		world = GWorld:new(levelWidth, levelHeight, Constants.CELL_SIZE),
		worldBarriers = {
			GWall:new(0, 0, levelWidth, Constants.WORLD_BARRIER_THICKNESS),
			GWall:new(
				0,
				levelHeight - Constants.WORLD_BARRIER_THICKNESS,
				levelWidth,
				Constants.WORLD_BARRIER_THICKNESS
			),
			GWall:new(0, 0, Constants.WORLD_BARRIER_THICKNESS, levelHeight),
			GWall:new(
				levelWidth - Constants.WORLD_BARRIER_THICKNESS,
				0,
				Constants.WORLD_BARRIER_THICKNESS,
				levelHeight
			),
		},
	}

	obj.world:addWalls(obj.worldBarriers)
	setmetatable(obj, GLevel)
end

function GLevel:configure()
	--- Do nothing
end

function GLevel:load()
	--- implement
end

return GLevel
