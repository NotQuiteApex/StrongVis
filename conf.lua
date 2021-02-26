sysW = 800
sysH = 600

function love.conf(t)
	t.identity = ".fourmc"
	t.appendidentity = true
	t.version = "11.3"
	t.console = false
	t.accelerometerjoystick = true
	t.externalstorage = false 
	t.gammacorrect = false

	t.audio.mic = false
	t.audio.mixwithsystem = true

	t.window.title = "FourCalc"
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