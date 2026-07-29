local GWorld = require("src.g_world")
local GWall = require("src.g_wall")
local GPlayer = require("src.g_player")
local GEnemy = require("src.g_enemy")
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
	world:addEntity(GEnemy:new(200, 200))
	world:addEntity(GEnemy:new(301, 200))
	world:addEntity(GEnemy:new(402, 200))
	world:addEntity(GEnemy:new(503, 200))
	world:addEntity(GEnemy:new(604, 200))
	world:addEntity(GEnemy:new(705, 200))
	world:addEntity(GEnemy:new(806, 200))
	world:addEntity(GEnemy:new(806, 210))
	world:addEntity(GEnemy:new(806, 220))
	world:addEntity(GEnemy:new(806, 230))
	world:addEntity(GEnemy:new(806, 240))
	world:addEntity(GEnemy:new(806, 250))
	world:addEntity(GEnemy:new(806, 260))
	world:addEntity(GEnemy:new(806, 270))
	world:addEntity(GEnemy:new(806, 280))
	world:addEntity(GEnemy:new(806, 290))
	world:addEntity(GEnemy:new(806, 300))
	world:addEntity(GEnemy:new(806, 310))
	world:addEntity(GEnemy:new(806, 320))
end

function love.update(dt)
	world:update(dt)
end

function love.draw()
	love.graphics.clear(0.12, 0.12, 0.12)
	world:draw()
end
