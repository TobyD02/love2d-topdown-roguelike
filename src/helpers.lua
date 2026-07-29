---@class Helpers
local Helpers = {}
Helpers.__index = Helpers

---@param t1 table
---@param t2 table
---@return table
function Helpers:concatenateArray(t1, t2)
	for i = 0, #t2 do
		t1[#t1 + 1] = t2[i]
	end

	return t1
end

---@param self Helpers
---@param t table
---@param iter number|nil
function Helpers:printTable(t, iter)
	if iter == nil then
		iter = 0
	end

	local prefix = ""
	for i = 0, iter do
		prefix = prefix .. "    "
	end

	for key, value in pairs(t) do
		print(prefix, key, value)

		if type(value) == "table" and iter + 1 < 5 then
			Helpers:printTable(value, iter + 1)
		end
	end
end

---@param self Helpers
---@param x number
---@param y number
function Helpers:normalize(x, y)
	if x == 0 and y == 0 then
		return 0, 0
	end

	local len = math.sqrt(x * x + y * y)
	x = x / len
	y = y / len

	return x, y
end

---@param self Helpers
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function Helpers:distance(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1
	return math.sqrt(dx * dx + dy * dy)
end

---@param self Helpers
---@param x number
---@param y number
---@param angle number
---@return number
---@return number
function Helpers:rotateVecByAngleDegrees(x, y, angle)
	angle = math.rad(angle)
	local cos = math.cos(angle)
	local sin = math.sin(angle)

	return x * cos - y * sin, x * sin + y * cos
end

return Helpers
