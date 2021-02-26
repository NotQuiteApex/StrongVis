-- FourCalc, calculator for Four's MC Speedruns

-- NOTES:
-- `/execute in minecraft:overworld run tp @s 1220.22 36.00 -923.30 10076.11 38.27`
-- X, Y, Z, Yaw, Pitch (ignore Y and Pitch, only use X, Z, Yaw)

io.stdout:setvbuf("no")

local lk = love.keyboard
local lg = love.graphics
local ls = love.system

function love.load()
	lg.setBackgroundColor(0, 0.5, 0.5)

	cmdstr = {
		state = 1,
		"",
		""
	}
end

function love.update(dt)

end

function love.draw()
	lg.print(cmdstr[1], 0, 00)
	lg.print(cmdstr[2], 0, 16)
end

function love.keypressed(k)
	if k == "v" and lk.isDown("lctrl","rctrl") then
		if cmdstr.state < 3 then
			cmdstr[cmdstr.state] = ls.getClipboardText()
			cmdstr.state = cmdstr.state + 1
		end
	end
end

function love.resize(w, h)
	sysW = w
	sysH = h
end