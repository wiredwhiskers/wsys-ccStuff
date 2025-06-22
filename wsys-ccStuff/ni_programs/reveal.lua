local message = arg[1]
assert(message, "Add message to reveal")
local staff = peripheral.find("wand")
local iotaT = fs.open("/iotas/reveal.txt","r")
local contents = iotaT.readAll()
iotaT.close()
staff.pushStack(message)
staff.pushStack(textutils.unserialize(contents))
staff.runPattern()