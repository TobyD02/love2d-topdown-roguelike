local Constants = require("src.constants")
local GSpriteSheetAnimation = require("src.core.g_sprite_sheet_animation")
---@class GSpriteSheet
---@field image love.Image
---@field quads love.Quad
---@field animations table<string, GSpriteSheetAnimation>
---@field currentAnimation string|nil
local GSpriteSheet = {}
GSpriteSheet.__index = GSpriteSheet

---@generic TSpriteSheet : GSpriteSheet
---@param self TSpriteSheet
---@param imagePath string
---@param quadWidth number
---@param quadHeight number
---@param quadSeparationX number|nil
---@param quadSeparationY number|nil
---@param quadOffsetX number|nil
---@param quadOffsetY number|nil
---@return TSpriteSheet
function GSpriteSheet:new(imagePath, quadWidth, quadHeight, quadSeparationX, quadSeparationY, quadOffsetX, quadOffsetY)
	local obj = {
		image = love.graphics.newImage(Constants.ASSETS_PATH .. imagePath),
		animations = {},
		currentAnimation = nil,
		quads = {},
	}

	if quadSeparationX == nil then
		quadSeparationX = 0
	end

	if quadSeparationY == nil then
		quadSeparationY = 0
	end

	if quadOffsetX == nil then
		quadOffsetX = 0
	end

	if quadOffsetY == nil then
		quadOffsetY = 0
	end

	for y = 0, obj.image:getHeight() - quadHeight, quadHeight do
		for x = 0, obj.image:getWidth() - quadWidth, quadWidth do
			local posX, posY = 0, 0
			if x ~= 0 then
				posX = x + quadSeparationX
			end

			if y ~= 0 then
				posY = y + quadSeparationY
			end
			table.insert(
				obj.quads,
				love.graphics.newQuad(
					quadOffsetX + posX,
					quadOffsetY + posY,
					quadWidth,
					quadHeight,
					obj.image:getDimensions()
				)
			)
		end
	end
	setmetatable(obj, GSpriteSheet)
	return obj
end

---@param self GSpriteSheet
---@param animation GSpriteSheetAnimation
function GSpriteSheet:addAnimation(animation)
	self.animations[animation.name] = animation
end

---@param self GSpriteSheet
---@param dt number
function GSpriteSheet:update(dt)
	if self.currentAnimation == nil then
		return
	end

	self.animations[self.currentAnimation]:update(dt)
end

function GSpriteSheet:play(animationName)
	if self.currentAnimation ~= animationName then
		self.currentAnimation = animationName
	end
end

---@param self GSpriteSheet
---@param x number
---@param y number
---@param rotation number
---@param scale number
function GSpriteSheet:draw(x, y, rotation, scale)
	if self.currentAnimation == nil then
		return
	end

	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(
		self.image,
		self.quads[self.animations[self.currentAnimation]:getFrame()],
		x,
		y,
		rotation,
		scale,
		scale
	)
end

return GSpriteSheet
