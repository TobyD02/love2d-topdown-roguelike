local GWorld = require("src.core.g_world")
local GWall = require("src.g_wall")
local GPlayer = require("src.g_player")
local GEnemySpitter = require("src.enemies.g_enemy_spitter")
local Constants = require("src.constants")
local GSpriteSheet = require("src.core.g_sprite_sheet")
local GSpriteSheetAnimation = require("src.core.g_sprite_sheet_animation")

---@type GWorld
local world = GWorld:new(Constants.WORLD_WIDTH, Constants.WORLD_HEIGHT, 24, 24)

---@type GSpriteSheet
local spriteSheet

function love.load()
	love.window.setMode(Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)
	love.graphics.setDefaultFilter("nearest", "nearest", 0) -- Set filter to nearest neighbors

	spriteSheet = GSpriteSheet:new("Dungeon_Character_2.png", 16, 15, 0, 1)
	spriteSheet:addAnimation(GSpriteSheetAnimation:new("idle", 1, { 1, 2 }))
	spriteSheet:addAnimation(GSpriteSheetAnimation:new("attack", 1, { 1 }))
	spriteSheet:play("idle")

	world:addWalls({
		GWall:new(0, 0, Constants.WORLD_WIDTH, 32),
		GWall:new(0, Constants.WORLD_HEIGHT - 32, Constants.WORLD_WIDTH, 32),
		GWall:new(0, 0, 32, Constants.WORLD_HEIGHT),
		GWall:new(Constants.WORLD_WIDTH - 32, 0, 32, Constants.WORLD_HEIGHT),
	})

	local wallSize = 128
	for _ = 1, 10 do
		local x = math.random(wallSize, Constants.WORLD_WIDTH - wallSize)
		local y = math.random(wallSize, Constants.WORLD_HEIGHT - wallSize)
		world:addWall(GWall:new(x, y, wallSize, wallSize))
	end

	local player = GPlayer:new(100, 100)
	world:addEntity(player)
	world:setCameraTarget(player)

	for _ = 1, 3 do
		local x = math.random(Constants.PLAYER_SIZE, Constants.WORLD_WIDTH / 5 - Constants.PLAYER_SIZE)
		local y = math.random(Constants.PLAYER_SIZE, Constants.WORLD_HEIGHT / 5 - Constants.PLAYER_SIZE)
		world:addEntity(GEnemySpitter:new(x, y))
	end
end

local flashTimer = 0

function love.update(dt)
	world:update(dt)
	spriteSheet:update(dt)

	flashTimer = flashTimer + dt
	if flashTimer >= 2 then
		spriteSheet:flash({ 1, 0, 0 }, 0.2)
		flashTimer = 0
	end
end

function love.draw()
	love.graphics.clear(0.12, 0.12, 0.12)
	world:draw()
	spriteSheet:draw(100, 100, 0, 5)
end
