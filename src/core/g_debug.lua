local Slab = require("lib.Slab")
local Constants = require("src.constants")

---@class GDebug
---@field logs string[]
---@field maxLogs number
local GDebug = {
	logs = {},
	maxLogs = 100,
}
GDebug.__index = GDebug

---@param self GDebug
---@param args table
function GDebug:initialise(args)
	Slab.Initialize(args)
	Slab.DisableDocks({ "Bottom", "Left", "Right" })
end

---@param self GDebug
---@param msg string
function GDebug:log(msg)
	table.insert(self.logs, 1, msg)

	if #self.logs > self.maxLogs then
		table.remove(self.logs, #self.logs)
	end
end

function GDebug:update(dt)
	Slab.Update(dt)
	Slab.BeginWindow("test window", {
		Title = "Log",
		BgColor = { 0, 0, 0, 0.3 },
		X = Constants.WINDOW_WIDTH - 600,
		Y = Constants.WINDOW_HEIGHT - 200,
		W = 600,
		H = 200,
		AutoSizeWindow = false,
	})

	if #self.logs == 0 then
		Slab.Text("Call GDebug:log to add a log message")
	else
		for _, log in ipairs(self.logs) do
			Slab.Text(log)
		end
	end

	Slab.EndWindow()
end

function GDebug:draw()
	Slab.Draw()
end

return GDebug
