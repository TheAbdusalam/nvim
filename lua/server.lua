local socket = require("socket")

local function receiveRequest(client)
  local request = ""
  local line, err

  -- Receive the request line by line until we get an empty line
  repeat
    line, err = client:receive()
    if not err then
      request = request .. line .. "\n"
    end
  until err or line == ""

  return request, err
end

local function sendResponse(client)
  local response = "HTTP/2 200 OK\r\n"
  response = response .. "Content-Type: text/plain\r\n"
  response = response .. "\r\n"
  response = response .. "Hello, World!"

  client:send(response)
end

local server = assert(socket.bind("*", 3200))
local ip, port = server:getsockname()

print("HTTP Server running on " .. ip .. ":" .. port)

while true do
  local client = server:accept()
  client:settimeout(60)

  local request, err = receiveRequest(client)

  if not err then
    print("Received request:\n" .. request)
    sendResponse(client)
  else
    print("Error receiving request: " .. err)
  end

  client:close()
end
