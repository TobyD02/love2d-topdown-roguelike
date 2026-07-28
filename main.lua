local GWorld = require("src.g_world")
local GWall = require("src.g_wall")
local GPlayer = require("src.g_player")

---@type GWorld
world = GWorld:new(64, 24, 24)

function love.load()
	love.window.setMode(960, 540)

	world:addWalls({
		GWall:new(0, 0, 960, 32),
		GWall:new(0, 508, 960, 32),
		GWall:new(0, 0, 32, 960),
		GWall:new(928, 0, 32, 540),
	})

	world:addEntity(GPlayer:new(100, 100, 20, 20))
end

function love.update(dt)
	world:update(dt)
end

function love.draw()
	love.graphics.clear(0.12, 0.12, 0.12)
	world:draw()
end
