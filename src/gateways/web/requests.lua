--local http       = require("http.request")

local Requests   = {
    config = nil,
    addr = nil,
    port = nil,
    protocol = nil,
    server = nil,
}

Requests.__index = Requests

function Requests:new()
    return setmetatable({}, Requests)
end

function Requests:setup(config)
    self.config = config
    self.addr = self.config.json["api"]["addr"]
    self.port = self.config.json["api"]["port"]
    self.protocol = self.config.json["api"]["gateways"]["web"]["protocol"]
    self.server = string.format("%s://%s:%i", self.protocol, self.addr, self.port)
end

function Requests:post(url, content, content_type)
    local request = http.new_from_uri(self.server .. url)
    request.headers:upsert(":method", "POST")
    request.headers:upsert("Content-Type", content_type)
    request:set_body(content)

    local headers = request:go(1)
    return headers and headers:get(":status") == "200"
end

return Requests
