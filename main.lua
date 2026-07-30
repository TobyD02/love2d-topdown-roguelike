local GWorld = require("src.g_world")
local GWall = require("src.g_wall")
local GPlayer = require("src.g_player")
local GEnemySpitter = require("src.enemies.g_enemy_spitter")
local Tags = require("src.tags")

---@type GWorld
local world = GWorld:new(64, 24, 24)

function love.load()
	love.window.setMode(960, 540)

	world:addWalls({
		GWall:new(0, 0, 960, 32),
		GWall:new(0, 508, 960, 32),
		GWall:new(0, 0, 32, 960),
		GWall:new(928, 0, 32, 540),
	})

	world:addEntity(GPlayer:new(100, 100))
	world:addEntity(GEnemySpitter:new(120, 100))
	world:addEntity(GEnemySpitter:new(140, 100))
	world:addEntity(GEnemySpitter:new(160, 100))
	world:addEntity(GEnemySpitter:new(180, 100))
	world:addEntity(GEnemySpitter:new(200, 100))
	world:addEntity(GEnemySpitter:new(220, 100))
	world:addEntity(GEnemySpitter:new(240, 100))
	world:addEntity(GEnemySpitter:new(260, 100))
	world:addEntity(GEnemySpitter:new(280, 100))
	world:addEntity(GEnemySpitter:new(300, 100))
end

function love.update(dt)
	world:update(dt)
end

function love.draw()
	love.graphics.clear(0.12, 0.12, 0.12)
	world:draw()
end
