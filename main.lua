-- StrongVis, visualizes directions of where a stronghold in Minecraft

--[[
Copyright (c) 2021 Logan "NotQuiteApex" Hickok-Dickson

This software is provided 'as-is', without any express or implied warranty. In
no event will the authors be held liable for any damages arising from the use of
this software.

Permission is granted to anyone to use this software for any purpose, including
commercial applications, and to alter it and redistribute it freely, subject to
the following restrictions:

1.  The origin of this software must not be misrepresented; you must not claim
    that you wrote the original software. If you use this software in a product,
    an acknowledgment in the product documentation would be appreciated but is
    not required.

2.  Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

3.  This notice may not be removed or altered from any source distribution.
--]]

-- NOTES:
-- `/execute in minecraft:overworld run tp @s -1220.22 36.00 -923.30 554.61 38.27`
-- `/execute in minecraft:overworld run tp @s -1220.22 36.00 -923.30 -188.60 38.27`
-- `/execute in minecraft:overworld run tp @s -1220.22 36.00 -1000.00 0.00 38.27`
-- X, Y, Z, Yaw, Pitch (ignore Y and Pitch, only use X, Z, Yaw)
-- South: +Z (0 deg)
-- North: -Z (180/-180 deg)
-- West:  -X (90 deg)
-- East:  +X (-90 deg)

io.stdout:setvbuf("no")

local le = love.event
local lk = love.keyboard
local lg = love.graphics
local lm = love.mouse
local ls = love.system
local lt = love.timer

local controlsstroffset = 128
local controlsstr = [[Controls:
Arrow keys to move cursor
Mouse 2 to pan view
MouseWheel to zoom
~ to restart app
Escape to exit
Ctrl+Z to undo last line
Ctrl+V to paste MC's F3+C
R to recenter view
]]

function love.load()
	lg.setLineStyle("rough")
	lk.setKeyRepeat(true)

	cmdstr = {
		state = 1
	}

	camerax = 0
	cameray = 0
	zoom = 1
	zoomfac = 0

	originx = -0.5
	originz = -0.5

	tilenum = 450 -- MUST be divisible by 10.
	raylen = tilenum * 10 * math.sqrt(2) + 50
	canvsize = tilenum*16
	canvhalf = canvsize/2

	linestate = "none" -- "none", "first", "second"
	lines = {}
	hasdrawnfirst = false
	hasdrawnsecond = false

	lg.setDefaultFilter("linear", "nearest")
	canv = lg.newCanvas(canvsize, canvsize)

	lg.setCanvas(canv)
		lg.push()
		lg.translate(canvhalf, canvhalf)
		lg.setColor(1, 0, 1)
		for y = 0, tilenum-1 do
			for x = 0, tilenum-1 do
				if (y+x) % 2 == 0 then
					lg.setColor(0.125, 0.125, 0.125)
					lg.rectangle("fill", -canvhalf + x*16, -canvhalf + y*16, 16, 16)
					lg.setColor(1, 0, 1)
				end
				lg.rectangle("fill", -canvhalf + x*16+7, -canvhalf + y*16+7, 1, 1)
			end
		end

		lg.setColor(0, 0.25, 0.25)
		for y = 0, tilenum do
			lg.line(-canvhalf, -canvhalf + y*16, canvhalf, -canvhalf + y*16)
		end
		for x = 0, tilenum do
			lg.line(-canvhalf + x*16, -canvhalf, -canvhalf + x*16, canvhalf)
		end

		lg.setColor(1, 0, 0)
		for y = 0, tilenum/10 do
			lg.line(-canvhalf, -canvhalf + y*16*10-8*10, canvhalf, -canvhalf + y*16*10-8*10)
		end
		for x = 0, tilenum/10 do
			lg.line(-canvhalf + x*16*10-8*10, -canvhalf, -canvhalf + x*16*10-8*10, canvhalf)
		end

		-- main lines
		lg.setColor(0, 1, 0)
		lg.line(-canvhalf,0, canvhalf,0)
		lg.line(0,-canvhalf, 0,canvhalf)
		lg.pop()
	lg.setCanvas()
end

function love.update(dt)
	if linestate ~= "none" and lm.isDown(1) then
		local mx = (lm.getX()-sysW/2)/zoom-camerax
		local my = (lm.getY()-sysH/2)/zoom-cameray
		local mang = math.atan2(-mx+originx, my-originz) + math.pi/2

		if not lines[linestate] then lines[linestate] = {} end
		lines[linestate].x = mx
		lines[linestate].z = my
		lines[linestate].rad = mang
	end
end

function love.draw()
	local fnt = lg.getFont()

	local mx = (lm.getX()-sysW/2)/zoom-camerax
	local my = (lm.getY()-sysH/2)/zoom-cameray
	local mang = math.atan2(-mx+originx, my-originz)

	lg.setScissor(0,0, sysW, sysH)

	lg.push()
	lg.translate(sysW/2, sysH/2)
	lg.scale(zoom, zoom)
	lg.translate(camerax, cameray)

	lg.draw(canv, -canvhalf, -canvhalf)

	lg.setColor(1, 0, 1)
	local x,y, a,b
	for i,v in ipairs(cmdstr) do
		if i == 1 then
			x, y = -0.5,-0.5
		elseif hasdrawnsecond then
			x, y = originx,originz
		else
			break
		end
		lg.circle("line", x+200*math.cos(v.rad), y+200*math.sin(v.rad), 4)
		lg.circle("line", x+200*math.cos(v.rad), y+200*math.sin(v.rad), 2/zoom)
	end

	lg.setColor(1,1,1)
	for k,v in pairs(lines) do
		if k == "first" then
			x, y = -0.5, -0.5
		else
			x, y = originx,originz --lines[k].x, lines[k].z
		end
		lg.line(x, y, x+raylen*math.cos(lines[k].rad), y+raylen*math.sin(lines[k].rad))
	end

	local xcoord, ycoord
	local fntscale = math.max(1/zoom,1)
	lg.setColor(0, 1, 1)
	for y = 0, tilenum/10-1 do
		local ystr = (y-(tilenum/10-1)/2)*10
		local w, h = fnt:getWidth(ystr), fnt:getHeight(ystr)
		ycoord = -canvhalf + y*10*16+4.5*16+8
		if -ycoord >= cameray - sysH/2/zoom and -ycoord <= cameray + sysH/2/zoom then
			for x = 0, tilenum/10 do
				xcoord = -canvhalf + x*10*16
				lg.print(ystr, xcoord, ycoord, 0, fntscale,fntscale, w/2, 8)
			end
		end
	end
	lg.setColor(1,1,0)
	for x = 0, tilenum/10-1 do
		local xstr = (x-(tilenum/10-1)/2)*10
		local w, h = fnt:getWidth(xstr), fnt:getHeight(xstr)
		xcoord = -canvhalf + (x-1)*10*16+15*16
		if -xcoord >= camerax - sysW/2/zoom and -xcoord <= camerax + sysW/2/zoom then
			for y = 0, tilenum/10 do
				ycoord = -canvhalf + y*10*16
				lg.print(xstr, xcoord, ycoord, 0, fntscale,fntscale, w/2, 8)
			end
		end
	end

	lg.setColor(1,1,1, 0.25)

	if zoom >= 8 then
		for y = 0, sysH/zoom+1 do
			for x = 0, sysW/zoom+1 do
				lg.rectangle("line", math.floor(-camerax + x-sysW/zoom/2), math.floor(-cameray + y-sysH/zoom/2), 1,1)
			end
		end
	end

	lg.setColor(1,1,1)
	lg.circle("line", math.floor(mx)+0.5, math.floor(my)+0.5, 2)
	lg.rectangle("line", math.floor(mx), math.floor(my), 1,1)

	lg.pop()

	lg.setScissor()

	lg.setColor(0,0,0, 0.75)
	lg.rectangle("fill", 0, 60, 110, 120) -- coords and angle
	lg.rectangle("fill", 0, 0, 260, 16*(#cmdstr+1)) -- fps & cmdstr
	lg.rectangle("fill", sysW-170, sysH-controlsstroffset, 170,controlsstroffset) -- controls
	lg.rectangle("fill", 0, sysH/2-8, 58,16) -- west
	lg.rectangle("fill", sysW-58, sysH/2-8, 58,16) -- east
	lg.rectangle("fill", sysW/2-fnt:getWidth("North (-Z)")/2, 0, fnt:getWidth("North (-Z)"), 16)
	lg.rectangle("fill", sysW/2-fnt:getWidth("South (+Z)")/2, sysH-16, fnt:getWidth("South (+Z)"), 16)

	lg.setColor(1,1,1)

	for i=1,2 do
		if cmdstr[i] then
			local str = "{ x=%.2f, z=%.2f, ang=%.2f }"
			lg.print(str:format(cmdstr[i].x,cmdstr[i].z,cmdstr[i].ang), 0, 16*i)
		end
	end

	lg.print(("X:        %.2f"):format(mx), 0, 64)
	lg.print(("Y:        %.2f"):format(my), 0, 80)
	lg.print(("Angle:   %.2f"):format(math.deg(mang)), 0, 96)
	lg.print(("OriginX: %.1f"):format(originx), 0, 112)
	lg.print(("OriginY: %.1f"):format(originz), 0, 128)

	local cx, cy = math.floor(mx / 16), math.floor(my / 16)
	if cx < 0 then cx = cx + 1 end
	if cy < 0 then cy = cy + 1 end
	lg.print(("Chunk X: %d"):format(cx), 0, 144+6)
	lg.print(("Chunk Z: %d"):format(cy), 0, 160+6)

	lg.setColor(1, 0.25, 1)
	lg.print("West (-X)", 0, sysH/2-8)
	lg.print("East (+X)", sysW-58, sysH/2-8)
	lg.print("North (-Z)", sysW/2-fnt:getWidth("North (-Z)")/2, 0)
	lg.print("South (+Z)", sysW/2-fnt:getWidth("South (+Z)")/2, sysH-16)

	lg.setColor(1,1,1)
	lg.printf(controlsstr, sysW-2, sysH-1, sysW, "right", 0, 1, 1, sysW, controlsstroffset)

	lg.print("fps:"..lt.getFPS(), 0,0)

	if linestate ~= "none" then
		local str = "Draw the "..linestate.." line."
		lg.print(str, sysW/2-fnt:getWidth(str), sysH-32, 0, 2,2)
	end
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

			-- normalize angle between -180 and 180
			local ang = v[4]
			ang = ang % 360
			if ang >= 180 then
				ang = ang - 360
			end
			if ang <- 180 then 
				ang = ang + 360
			end
			print(v[4], 180 * math.floor((v[4] + 180) / 180))
			cmdstr[cmdstr.state] = {x=v[1], z=v[3], ang=v[4], rad=math.rad(ang)+math.pi/2}
			if cmdstr.state == 1 then
				--originx = v[1]
				--originz = v[3]
				linestate = "first"
			else
				camerax = 0
				cameray = 0
				zoomfac = 0
				zoom = 1/(1.1^zoomfac)
				lg.setLineWidth(1/zoom)
				linestate = "second"
			end

			cmdstr.state = cmdstr.state + 1
		end
	elseif k == "z" and lk.isDown("lctrl","rctrl") then
		-- undo last paste and line.
		if linestate == "second" or #lines == 2 or #cmdstr == 2 then
			originx = -0.5
			originz = -0.5
			linestate = "none"
			lines["second"] = nil --table.remove(lines, "second")
			cmdstr.state = 2
			table.remove(cmdstr, 2)
		elseif linestate == "first" or #lines == 1 or #cmdstr == 1 then
			originx = -0.5
			originz = -0.5
			linestate = "none"
			lines["first"] = nil --table.remove(lines, "first")
			cmdstr.state = 1
			table.remove(cmdstr, 1)
		end
	elseif k == "r" then
		camerax = 0
		cameray = 0
		zoomfac = 0
		zoom = 1/(1.1^zoomfac)
		lg.setLineWidth(1/zoom)
	elseif k == "up" then    lm.setY(lm.getY() - 2)
	elseif k == "down" then  lm.setY(lm.getY() + 2)
	elseif k == "left" then  lm.setX(lm.getX() - 2)
	elseif k == "right" then lm.setX(lm.getX() + 2)
	elseif k == "`" then
		le.quit("restart")
	elseif k == "escape" then
		le.quit()
	end
end

function love.resize(w, h)
	sysW = math.floor(w/2)*2
	sysH = math.floor(h/2)*2
end

function love.mousemoved(x,y, dx,dy, istouch)
	if lm.isDown(2) then
		camerax = camerax + dx/zoom
		cameray = cameray + dy/zoom
	end
end

function love.wheelmoved(x, y)
	local oldzoom = 1/(1.1^zoomfac)
	zoomfac = clamp(zoomfac - y*2, -36, 10)
	zoom = 1/(1.1^zoomfac)

	print(zoomfac)

	camerax = ((lm.getX()-sysW/2)/zoom - (lm.getX()-sysW/2)/oldzoom) + camerax
	cameray = ((lm.getY()-sysH/2)/zoom - (lm.getY()-sysH/2)/oldzoom) + cameray

	lg.setLineWidth(1/zoom)
end

function love.mousepressed(x, y, b)
	if b == 1 then
		if linestate == "second" then
			originx = math.floor((lm.getX()-sysW/2)/zoom-camerax) + 0.5
			originz = math.floor((lm.getY()-sysH/2)/zoom-cameray) + 0.5
			hasdrawnsecond = true
		end

		if linestate ~= "none" then
			local i = #cmdstr
			local v = cmdstr[i]
			local x,y
			if i == 1 then
				x, y = -0.5,-0.5
			elseif hasdrawnsecond then
				x, y = originx,originz
			else
				return
			end
			if i == 1 then
				camerax = -math.floor(200*math.cos(v.rad))
				cameray = -math.floor(200*math.sin(v.rad))
			elseif hasdrawnsecond then
				camerax = -math.floor(200*math.cos(v.rad)) - originx
				cameray = -math.floor(200*math.sin(v.rad)) - originz
			end
			zoomfac = -36
			zoom = 1/(1.1^zoomfac)

			lg.setLineWidth(1/zoom)
		end
	end
end

function love.mousereleased(x, y, b)
	if b == 1 then
		if linestate ~= "none" then
			linestate = "none"
		end
	end
end

function sign(x)
	return x < 0 and -1 or 1
end

function clamp(x, min, max)
	return x < min and min or (x > max and max or x)
end
