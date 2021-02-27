-- FourCalc, calculator for Four's MC Speedruns

-- NOTES:
-- `/execute in minecraft:overworld run tp @s 1220.22 36.00 -923.30 10076.11 38.27`
-- X, Y, Z, Yaw, Pitch (ignore Y and Pitch, only use X, Z, Yaw)

io.stdout:setvbuf("no")

local le = love.event
local lk = love.keyboard
local lg = love.graphics
local lm = love.mouse
local ls = love.system

function love.load()
	lg.setLineStyle("rough")

	cmdstr = {
		state = 1,
		"",
		""
	}

	camerax = 0
	cameray = 0
	zoom = 1
end

function love.update(dt)

end

function love.draw()
	lg.push()
	lg.translate(sysW/2, sysH/2)
	lg.translate(camerax, cameray)
	lg.scale(zoom, zoom)

	lg.setColor(1, 0, 1)
	for y = 0, 255 do
		for x = 0, 255 do
			lg.rectangle("fill", -2048 + x*16+8, -2048 + y*16+8, 1, 1)
		end
	end

	lg.setColor(0.25, 0.25, 0.25)
	for y = 0, 256 do
		lg.line(-2048, -2048 + y*16, 2048, -2048 + y*16)
	end
	for x = 0, 256 do
		lg.line(-2048 + x*16, -2048, -2048 + x*16, 2048)
	end

	-- main lines
	lg.setColor(1,0,1)
	lg.line(-5000,0, 5000,0)
	lg.line(0,-5000, 0,5000)
	
	lg.pop()

	lg.print(cmdstr[1], 0, 00)
	lg.print(cmdstr[2], 0, 16)
end

function love.keypressed(k)
	if k == "v" and lk.isDown("lctrl","rctrl") then
		if cmdstr.state < 3 then
			cmdstr[cmdstr.state] = ls.getClipboardText()
			cmdstr.state = cmdstr.state + 1
		end
	elseif k == "`" then
		le.quit("restart")
	elseif k == "escape" then
		le.quit()
	end
end

function love.resize(w, h)
	sysW = w
	sysH = h
end

function love.mousemoved(x,y, dx,dy, istouch)
	if lm.isDown(2) then
		camerax = camerax + dx
		cameray = cameray + dy
	end
end

function love.wheelmoved(x, y)
	zoom = math.max(zoom + y, 1)
end