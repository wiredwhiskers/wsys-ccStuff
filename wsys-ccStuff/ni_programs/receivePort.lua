local c = require "/home/cast"
local interface = peripheral.wrap("back")
local speaker = peripheral.wrap("top")
local staff = peripheral.wrap("left")
local canvas = interface.canvas()
canvas.clear()

--establish focal port display group
local iotaGroup = canvas.addGroup({0,0})
iotaGroup.addRectangle(2,10,55,5,0x00000066)
local text = iotaGroup.addText({3,11},"")
text.setScale(.35)
rednet.open("bottom")

while true do
    local event, sender, message, protocol = os.pullEvent("rednet_message")
    if sender == 191 then
        text.setText(message)
        if string.sub(message, 2, 5) == "dcad" then
            local command = string.sub(message,7, -2)
            print(command)
            staff.pushStack("dyncad")
            c.cast("libRead")
            c.read(command)
            staff.runPattern("SOUTH_WEST", "aawq")
        elseif string.sub(message,2,5) == "save" then
            local command = string.sub(message,7,-2)
            print("saved: "..command)
            c.save(command)
        elseif string.sub(message,2,5) == "cast" then
            local command = string.sub(message,7,-2)
                if string.sub(message,7,8) == "tp" then
                    print("tp detected")
                    local subcommand = string.sub(message,10,-2)
                    staff.pushStack(subcommand)
                    c.cast("tp")
                    staff.clearStack()
                else
                    c.cast(command)
                end
        elseif string.sub(message,2,7) == "status" then
            print("yeah that works")
            staff.pushStack("dyncad")
            c.cast("libRead")
            print(staff.getStack())
            c.cast("status")
            print(staff.getStack())
        elseif string.sub(message,2,6) == "write" then
            local command = string.sub(message,8, -2)
            c.read(command)
            print("writing:"..command)
            c.cast("writeIota")
        end
        sleep(.9)
        text.setText("")
    else
        print(sender..": "..textutils.serialize(message))
    end
end
