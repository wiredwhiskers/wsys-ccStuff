peripheral.find("modem",rednet.open)
while true do
  local id, packet = rednet.receive("HTTP")
  connection,type,path,data = table.unpack(packet)
  --type =
  local fspath = table.concat(path,"/")
  local file = fs.open("/www/"..fspath, "r")
  if file then
    resp = file.readAll()
  else
    resp = "this is the default text response, no file found or another error occured"
  end
  rednet.send(id,{connection, resp}, "HTTP")
end 
