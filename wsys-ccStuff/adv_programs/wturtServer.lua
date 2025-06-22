name = arg[1]
pass = arg[2]
channel = arg[3]
local ServCmds = {}
rednet.open("top")
rednet.host("WRCT","turtserv")

ServCmds = {
    toTurt = function(args)
        command = stringSplit(args, " ")
        rednet.send(tonumber(command[2]),table.concat(command, " ",3),"WRCT")
    end,
    meow = function()
        irc.send(channel, "meow")
    end,
    listTurt = function()
        connections = {rednet.lookup("turtResponse")}
        if #connections>0 then
            irc.send(channel, "Turtles Currently Connected: "..table.concat(connections, ", "))
        elseif #connections<=0 then
            irc.send(channel, "No Turtles connected")
        else
            irc.send(channel, "Turtle Currently Connected: "..connections[1])
        end
    end
}

function stringSplit(inputstr, sep)
    inputstr = sep .. inputstr:gsub(sep, string.char(2) .. sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^"..string.char(2).."]+)") do
        table.insert(t, string.sub(str,2))
    end
    return t
end

function packetHandler(packet)
    local tab = {}
    tab["type"] = packet["type"]
    tab["content"] = packet["content"]
    if tab["type"] == "TABLE" then
        irc.send(channel,table.concat(tab["content"], "/\n"))
    elseif tab["type"] == "STRING" then
        irc.send(channel,tab["content"])
    end
end

assert(pass, "enter password")
assert(name, "enter a username")
if channel == nil then channel = "#irctest" end

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
                term.setCursorPos(1,termHeight)
                term.write(">" ..typemessage)
                command = stringSplit(message[4], " ")
                if message[3] == channel then
                    if message[2] == "wturt" then
                    else
                        handler = ServCmds[command[1]]
                        if handler then
                            handler(message[4])
                        else
                        end
                    end
                else
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
            id,message,_ = rednet.receive("WRCT")
            if message then
                packetHandler(message)
                id,message,_ = nil
            end
        end
    end)
end

irc = require("IRC").connect(main,name,name,name,pass)
 
