local modem = peripheral.find("modem")
local turtID = "turt"..math.random(100)
local TurtCmd = {}
local x,y,z = gps.locate()

TurtCmd = {
  meow = function()
    print("meow")
  end,
  echo = function(args)
    echoText = stringSplit(args," ")
    rednet.send(223,"Echoing: "..table.concat(echoText, " ",2),"WRCT")
  end,
  name = function(args)
        nameText = stringSplit(args," ")
        table.remove(nameText, 1)
        if #args == 0 then
            os.setComputerLabel(nil)
        else
            os.setComputerLabel(table.concat(nameText, " "))
            rednet.send(223,"Name Set: "..table.concat(nameText, " "),"WRCT")
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
    move = function(args)
        moveText = stringSplit(args," ")
        table.remove(moveText, 1)
        local tab = {}
        local l = #moveText
        for i=1,l,2 do
            tab[moveText[i]] = moveText[i+1]
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
              rednet.send(223, "Moved "..k.." by "..step,"WRCT")
        end
    end,
    turnLeft = function()
      turtle.turnLeft()
    end,
    turnRight = function()
      turtle.turnRight()
    end,

}

rednet.open("left")
rednet.host("turtResponse",turtID)

function packetResponse(type,dest,protocol,content)
  local packetTab = {}
  packetTab["type"] = type
  packetTab["content"] = content
  rednet(dest,packetTab,protocol)
end

function stringSplit(inputstr, sep)
    inputstr = sep .. inputstr:gsub(sep, string.char(2) .. sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^"..string.char(2).."]+)") do
        table.insert(t, string.sub(str,2))
    end
    return t
end

while true do
  id,message,_ = rednet.receive("WRCT")
  if id == rednet.lookup("WRCT", "turtserv") then
    command = stringSplit(message," ")
    handler = TurtCmd[command[1]]
    if handler then
      handler(message)
    else
    end
  else
    print("Unauthorized Access by:"..id..". Message: "..message)
  end
end 
