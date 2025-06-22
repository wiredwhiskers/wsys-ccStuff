local file = arg[1]
assert(file, "Specify Iota to cast")
local staff = peripheral.find("wand")
local iotaT = fs.open("/iotas/"..file..".txt","r")
local contents = iotaT.readAll()
iotaT.close()
staff.pushStack(textutils.unserialize(contents))
staff.runPattern() 
