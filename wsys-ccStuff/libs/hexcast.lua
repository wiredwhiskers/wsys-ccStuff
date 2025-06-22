function cast(file)
    local staff = peripheral.find("wand")
    local iotaT = fs.open("/iotas/"..file..".txt", "r")
    local contents = iotaT.readAll()
    iotaT.close()
    staff.pushStack(textutils.unserialize(contents))
    staff.runPattern()
end

function read(file)
    local staff = peripheral.find("wand")
    local iotaT = fs.open("/iotas/"..file..".txt", "r")
    local contents = iotaT.readAll()
    iotaT.close()
    staff.pushStack(textutils.unserialize(contents))
end

function save(name)
    local staff = peripheral.find("wand")
    local file = fs.open("/iotas/"..name..".txt", "w")
    staff.runPattern("EAST","aqqqqq")
    iota = staff.popStack()
    file.write(textutils.serialize(iota))
    file.close()
end

return { cast = cast, read = read, save = save}
 
