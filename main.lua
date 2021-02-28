-- FourCalc, calculator for Four's MC Speedruns

-- NOTES:
-- `/execute in minecraft:overworld run tp @s -1220.22 36.00 -923.30 10076.11 38.27`
-- X, Y, Z, Yaw, Pitch (ignore Y and Pitch, only use X, Z, Yaw)

io.stdout:setvbuf("no")

local le = love.event
local lk = love.keyboard
local lg = love.graphics
local lm = love.mouse
local ls = love.system
local lt = love.timer

function love.load()
	lg.setLineStyle("rough")
	lk.setKeyRepeat(true)

	cmdstr = {
		state = 1
	}

	camerax = 0
	cameray = 0
	zoom = 1

	originx = 0
	originz = 0

	lg.setDefaultFilter("linear", "nearest")
	canv = lg.newCanvas(4096, 4096)

	lg.setCanvas(canv)
		lg.push()
		lg.translate(2048, 2048)
		lg.setColor(1, 0, 1)
		for y = 0, 255 do
			for x = 0, 255 do
				if (y+x) % 2 == 0 then
					lg.setColor(0.125, 0.125, 0.125)
					lg.rectangle("fill", -2048 + x*16, -2048 + y*16, 16, 16)
					lg.setColor(1, 0, 1)
				end
				lg.rectangle("fill", -2048 + x*16+8, -2048 + y*16+8, 1, 1)
			end
		end

		lg.setColor(0, 0.25, 0.25)
		for y = 0, 256 do
			lg.line(-2048, -2048 + y*16, 2048, -2048 + y*16)
		end
		for x = 0, 256 do
			lg.line(-2048 + x*16, -2048, -2048 + x*16, 2048)
		end

		-- main lines
		lg.setColor(1, 0, 0)
		lg.line(-2048,0, 2048,0)
		lg.line(0,-2048, 0,2048)
		lg.pop()
	lg.setCanvas()
end

function love.update(dt)
	lg.setLineWidth(1/zoom)
end

function love.draw()
	lg.push()
	lg.translate(sysW/2, sysH/2)
	lg.scale(zoom, zoom)
	lg.translate(camerax, cameray)

	lg.draw(canv, -2048, -2048)

	for i=1,2 do
		if cmdstr[i] then
			local x, y = cmdstr[i].x - originx, cmdstr[i].z - originz
			lg.line(x, y, x+5000*math.cos(cmdstr[i].rad), y-5000*math.sin(cmdstr[i].rad))
		end
	end

	lg.pop()

	for i=1,2 do
		if cmdstr[i] then
			local str = "{ x=%.2f, z=%.2f, ang=%.2f }"
			lg.print(str:format(cmdstr[i].x,cmdstr[i].z,cmdstr[i].ang), 0, 16*i)
		end
	end

	lg.print("mx:"..(lm.getX()-sysW/2)/zoom-camerax, 0, 64)
	lg.print("my:"..(lm.getY()-sysH/2)/zoom-cameray, 0, 80)

	lg.setColor(1,1,1)
	local fnt = lg.getFont()
	local str = "Controls:\nMouse1 to idk\nMouse 2 to pan\nMouseWheel to zoom"
	lg.printf(str, sysW-2, sysH, sysW, "right", 0, 1, 1, sysW, 58)

	lg.print("fps:"..lt.getFPS(), 0,0)
end

function love.keypressed(k)
	if k == "v" and lk.isDown("lctrl","rctrl") then
		if cmdstr.state < 3 then
			local txt = ls.getClipboardText()

			if txt:sub(1,42) ~= "/execute in minecraft:overworld run tp @s " then
				return -- error, wrong string format
			end

			local v = {}
			for cap in txt:gmatch("(%-?%d*%.?%d+)") do
				local n = tonumber(cap)
				if not n then return end
				v[#v+1] = n
			end

			if #v ~= 5 then
				return -- error, not enough numbers
			end

			cmdstr[cmdstr.state] = {x=v[1], z=v[3], ang=v[4] % 360, rad=math.rad(v[4] % 360)}
			if cmdstr.state == 1 then
				originx = v[1]
				originz = v[3]
			end

			cmdstr.state = cmdstr.state + 1
		end
	elseif k == "up" then    lm.setY(lm.getY() - 1)
	elseif k == "down" then  lm.setY(lm.getY() + 1)
	elseif k == "left" then  lm.setX(lm.getX() - 1)
	elseif k == "right" then lm.setX(lm.getX() + 1)
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
		camerax = camerax + dx/zoom
		cameray = cameray + dy/zoom
	end
end

function love.wheelmoved(x, y)
	zoom = math.max(zoom + y/2, 1)
end