local Constants = {

	ASSETS_PATH = "assets/",

	CELL_SIZE = 64,
	PLAYER_SIZE = 32,
	BULLET_SIZE = 16,
	WORLD_WIDTH = 64 * 20,
	WORLD_HEIGHT = 64 * 20,
	WORLD_BARRIER_THICKNESS = 32,

	WINDOW_WIDTH = 1280,
	WINDOW_HEIGHT = 720,

	REMOVE_QUEUE_BUDGET = 32,
	ENTITY_LIMIT = 128,

	---Normal collision filter
	FILTER_SLIDE = "slide",

	---Collide but don't move others
	FILTER_TOUCH = "touch",

	---Ignore collisions
	FILTER_CROSS = "cross",

	TYPE_BULLET = "bullet",
	TYPE_PLAYER = "player",
	TYPE_WALL = "wall",
	TYPE_ENEMY = "enemy",

	DEBUG = true,
}

return Constants
