local Constants = {

	CELL_SIZE = 64,
	PLAYER_SIZE = 32,
	BULLET_SIZE = 24,

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
