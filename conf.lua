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

sysW = 800
sysH = 600

function love.conf(t)
	t.identity = ".strongvis"
	t.appendidentity = true
	t.version = "11.3"
	t.console = false
	t.accelerometerjoystick = true
	t.externalstorage = false 
	t.gammacorrect = false

	t.audio.mic = false
	t.audio.mixwithsystem = true

	t.window.title = "StrongVis"
	t.window.icon = nil
	t.window.width = sysW
	t.window.height = sysH
	t.window.borderless = false
	t.window.resizable = true
	t.window.minwidth = 400
	t.window.minheight = 240
	t.window.fullscreen = false
	t.window.fullscreentype = "desktop"
	t.window.vsync = 1
	t.window.msaa = 0
	t.window.depth = nil
	t.window.stencil = nil
	t.window.display = 1
	t.window.highdpi = false
	t.window.usedpiscale = true
	t.window.x = nil
	t.window.y = nil

	t.modules.audio = false
	t.modules.data = true
	t.modules.event = true
	t.modules.font = true
	t.modules.graphics = true
	t.modules.image = true
	t.modules.joystick = false
	t.modules.keyboard = true
	t.modules.math = true
	t.modules.mouse = true
	t.modules.physics = false
	t.modules.sound = false
	t.modules.system = true
	t.modules.thread = true
	t.modules.timer = true
	t.modules.touch = false
	t.modules.video = false
	t.modules.window = true
end