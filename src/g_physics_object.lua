---@class GPhysicsObject
---@field type string
local GPhysicsObject = {}
GPhysicsObject.__index = GPhysicsObject

---@generic TPhysicsObject
---@param type string
---@return TPhysicsObject
function GPhysicsObject:new(type)
	local obj = {
		type = type,
	}

	setmetatable(obj, self)
	return obj
end

return GPhysicsObject
