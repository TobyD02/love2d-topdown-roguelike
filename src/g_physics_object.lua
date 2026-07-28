---@class GPhysicsObject
---@field type string
local GPhysicsObject = {}
GPhysicsObject.__index = GPhysicsObject

---@param type string
---@return GPhysicsObject
function GPhysicsObject:new(type)
	local obj = {
		type = type,
	}

	setmetatable(obj, self)
	return obj
end

return GPhysicsObject
