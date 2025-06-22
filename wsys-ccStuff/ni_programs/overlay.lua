local message = arg[1]
local interface = peripheral.wrap("back")
local canvas = interface.canvas()
canvas.clear()

--create group
local visuals = canvas.addGroup({0,0})
local rect = visuals.addRectangle(2,100,55,5,0x00000066)
local text = visuals.addText({3,101},"")
text.setScale(.35)
rect.setSize(2+(#message*2),5)
text.setText(message)
shell.run("/wiredControls/core/cast.lua notif")
 
