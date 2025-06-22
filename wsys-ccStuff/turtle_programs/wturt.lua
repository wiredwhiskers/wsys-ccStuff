name = "wturt"
pass = "iloveircgaming"
channel = "#turtle"
locate = require("/gps")
bub = peripheral.wrap("chatter_1")
scanner = peripheral.wrap("universal_scanner_1")
modem = peripheral.wrap("modem_1")
speaker = peripheral.wrap("speaker_1")
wand = peripheral.wrap("wand_1")
camo = peripheral.wrap("mimic_1")
kc = peripheral.wrap("plethora:kinetic_1")
local x = 0
local y = 0
local z = 0

local nearby = {}

customc = {

    meow = function()
        irc.send(channel, "meow")
        if message[2] == "wired" then
        speaker.playSound("minecraft:entity.cat.ambient",2,math.random(2))
        end
    end,
    sight = function()
    local d,b = turtle.inspect()
    if d then
        irc.send(channel,"forward: "..textutils.serialize(b.name,{compact=true}))
    end
    d,b = turtle.inspectUp()
    if d then
        irc.send(channel,"above: "..textutils.serialize(b.name,{compact=true}))
    end
    d,b = turtle.inspectDown()
    if d then
        irc.send(channel,"below: "..textutils.serialize(b.name,{compact=true}))
    end
    b = scanner.scan("player",5)
    if b == nil then
    irc.send(channel,"no one nearby :(")
    else
    for k,v in ipairs(b) do
        nearby[k] = v.displayName
    end
    irc.send(channel,"Nearby Players: "..table.concat(nearby,", "))
    end
    end,

    dance = function()
        local prevBub = bub.getMessage()
        irc.send(channel, "Boogie Subroutine Active")
        bub.setMessage("Boogie Subroutine Active")
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.turnRight()
        turtle.turnRight()
        turtle.turnRight()
        turtle.turnRight()
        turtle.up()
        turtle.down()
        turtle.up()
        turtle.down()
        irc.send(channel, "Boogie Complete")
        bub.setMessage("Boogie Subroutine Complete")
        sleep(.5)
        bub.setMessage(prevBub)
    end,

    bubble = function(args)
        table.remove(args, 1)
        if #args == 0 then
            bub.clearMessage()
        else
            speaker.playSound("minecraft:entity.puffer_fish.blow_up",3)
            bub.setMessage(table.concat(args, " "))
            irc.send(channel, table.concat(args, " "))
        end
    end,

    name = function(args)
        table.remove(args, 1)
        if #args == 0 then
            os.setComputerLabel(nil)
        else
            os.setComputerLabel(table.concat(args, " "))
            irc.send(channel, table.concat(args, " "))
        end
    end,
    sound = function(args)
        volume = args[3] or 1
        pitch = args[4] or 1
        arg = args[2]
        if arg then
            speaker.playSound(arg,volume,pitch)
            irc.send(channel,"Playing: "..arg)
        end
    end,
    inv = function(reqSlot)
        local reqSlot = reqSlot[2] or nil
    local prevSlot = turtle.getSelectedSlot()
    local a = {}
    if reqSlot then
        if turtle.getItemDetail(reqSlot) then
            irc.send(channel, "Slot Contains "..turtle.getItemDetail(reqSlot).name)
        else
            irc.send(channel, "Slot Contains Nothing")
        end
    else
    for i=1,16 do
        turtle.select(i)
        if turtle.getItemDetail() then
            a[i] = turtle.getItemDetail().name
        else
            a[i] = "empty"
        end
    end
    irc.send(channel, "Inventory Contains:")
    irc.send(channel, table.concat(a, ", ",1,4))
    irc.send(channel, table.concat(a, ", ",5,8))
    irc.send(channel, table.concat(a, ", ",9,12))
    irc.send(channel, table.concat(a, ", ",13,16))
    end
    end,
    store = function(rs)
        local res = tonumber(rs[2]) or nil
        if turtle.getItemDetail(res) then
            turtle.select(16)
            b,s = turtle.place()
            if b then
                turtle.select(res)
                turtle.drop()
                turtle.select(16)
                turtle.dig()
                irc.send(channel, "Item Stored Successfully")
            else
                irc.send(channel, "whoops! couldn't place shulker")
            end
        else
            irc.send(channel, "whoops, no item to transfer")
        end
    end,
    gps = function()
        if not x then
            irc.send(channel, "GPS failed!")
        else
            irc.send(channel, "Turtle Located at: X: "..x..",Y: "..y..",Z: "..z)
        end
    end,
    help = function()
        local a = {}
        local i = 0
        for k,_ in pairs(customc) do
            i = i + 1
            a[i] = k
        end
        irc.send(channel,"Commands: "..table.concat(a,", "))
    end,
    move = function(args)
        table.remove(args, 1)
        local tab = {}
        local l = #args
        for i=1,l,2 do
            tab[args[i]] = args[i+1]
        end
        for k,v in pairs(tab) do
            local step = v
            if k == "left" then
                turtle.turnLeft()
                repeat
                    turtle.forward()
                    v = v - 1
                until v == 0
                turtle.turnRight()
            elseif k == "right" then
                turtle.turnRight()
                repeat
                    turtle.forward()
                    v = v - 1
                until v == 0
                turtle.turnLeft()
            else
                repeat
                    turtle[k]()
                    v = v - 1
                until v == 0
            end
            irc.send(channel, "Moved "..k.." by "..step)
        end
    end,
    kaboom = function()
        prevBub = bub.getMessage()
        bub.setMessage("Self Destruct Sequence Activated")
        sleep(.5)
        bub.setMessage("5")
        sleep(.5)
        bub.setMessage("4")
        sleep(.5)
        bub.setMessage("3")
        sleep(.5)
        bub.setMessage("2")
        sleep(.5)
        bub.setMessage("1")
        sleep(.5)
        speaker.playSound("minecraft:entity.generic.explode",3,1)
        sleep(1)
        bub.setMessage(prevBub)
        end,
        mimic = function(args)
            local blockChoice = {}
            d,b = turtle.inspectDown()
            if args[2] == "clone" then
                blockChoice["block"] = b.name
            else
                blockChoice["block"] = args[2]
            end
            if #args > 1 then
                camo.setMimic(blockChoice)
                irc.send(channel,blockChoice["block"])
            else
                camo.reset()
                irc.send(channel,"reset camo")
            end
        end,
        pattern = function(args)
            local patTab = {}
            if #args < 2 then
                irc.send(command, "Missing Arguements")
            else
            patTab[1] = {
                ["iota$serde"]="hextweaks:pattern",
                ["startDir"]=args[2],
                ["angles"]=args[3]
            }
            end
            wand.pushStack(patTab)
        end,
        runStack = function(args)
            if #args >= 2 then
            wand.runPattern(args[2],args[3])
            else
            wand.runPattern()
            end
            irc.send(channel, "Bonk!")
        end,
        forceQuit = function()
            if message[2] == "wired" then
                irc.send(nil,"quit")
            else
                irc.send(channel,"I'm sorry Dave, I'm afraid I can't do that.")
            end
        end,
        postoStack = function()
            local posTab = {
                ["iota$serde"]="hextweaks:vector3",
                ["x"] = x,
                ["y"] = y,
                ["z"] = z
            }
            wand.pushStack(posTab)
        end,
        reveal = function()
            wand.runPattern("NORTH_EAST","de")
        end,
        clearStack = function()
            wand.clearStack()
            irc.send(channel, "Stack Cleared")
        end,

}

function tableSearch(tab)
    if type(tab) == "table"  then
        for k,v in pairs(tab) do
            tableSearch(v)
        end
    else
        irc.send(channel, tostring(tab))
    end
end

assert(pass, "enter password")
assert(name, "enter a username")
if channel == nil then channel = "#turtle" end

local function stringSplit(inputstr, sep)
    inputstr = sep .. inputstr:gsub(sep, string.char(2) .. sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^"..string.char(2).."]+)") do
        table.insert(t, string.sub(str,2))
    end
    return t
end

function init()
    modem.transmit(65500,65500,"PING")

end

function main()

    _,termHeight = term.getSize()

    irc.join(channel)
    typemessage = ""

    parallel.waitForAny(
    function()
        while true do
            message = table.remove(irc.messageQueue,1)
            if message then
                term.scroll(1)
                term.setCursorPos(1,termHeight-1)
                term.clearLine()
                print(table.concat({message[1],"; ", message[2], ">" , message[3], ": ", message[4]}))
                command = stringSplit(message[4], " ")
                for c in pairs(command) do
                    local n = tonumber(command[c])
                    if n == nil then
                    else
                        command[c] = n
                    end
                end
                if message[3] == channel then
                if message[2] == "wturt" then
                else
                    handler = customc[command[1]]
                    if handler then
                        handler(command)
                    else
                        handler = turtle[command[1]]
                        if handler then
                        handler(command[2])
                        irc.send(channel, "Command Received: "..command[1])
                        end
                    end
                end
                else
                term.setCursorPos(1,termHeight)
                term.write(">" ..typemessage)
                end
            end
            sleep()
        end
    end,
    function()
        while true do
            event = {os.pullEvent()}
            if event[1] == "char" or event[1] == "key" then
                if event[1] == "char" then
                    typemessage = typemessage .. event[2]
                elseif event[1] == "key" then
                    if event[2] == 257 then

                        if string.sub(typemessage, 1, 1) == "/" then
                            irc.send(nil,typemessage:sub(2))
                        else
                            irc.send(channel,typemessage)
                        end

                        typemessage = ""
                    elseif event[2] == 259 then
                        typemessage = typemessage:sub(1, -2)
                    end
                end
                term.setCursorPos(1,termHeight)
                term.clearLine()
                term.write(">" ..typemessage)

            end
        end
    end,
    function()
        while true do
            local event, device, mishap, mishapdesc, pattern = os.pullEvent("mishap")
            irc.send(channel,"Mishap: "..mishap)
        end
    end,
    function()
        while true do
            local revent, rdevice, reveal = os.pullEvent("reveal")
            irc.send(channel,"Reveal:"..reveal)
        end
    end,
    function()
        while true do
            x,y,z = locate()
        end
    end)
end

irc = require("IRC").connect(main,name,name,name,pass)