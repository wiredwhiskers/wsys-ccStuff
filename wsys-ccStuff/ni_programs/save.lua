local name = arg[1]
local staff = peripheral.find("wand")
assert(name, "Name this Iota")
local file = fs.open("/iotas/"..name..".txt", "w")
staff.runPattern("EAST","aqqqqq")
iota = staff.popStack()
file.write(textutils.serialize(iota))
file.close()
 
