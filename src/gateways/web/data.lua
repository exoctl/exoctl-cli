local Data   = {
    config = nil,
    endpoints = { metadata = nil },
    requests = nil
}

Data.__index = Data

function Data:new()
    return setmetatable({}, Data)
end

function Data:setup(config, requests)
    self.config = config
    self.requests = requests
    self.endpoints.metadata = self.config.json["api"]["gateways"]["web"]["metadata"]
end

function Data:metadata(data)
    return self.requests:post(self.endpoints.metadata, data, "text/plain")
end

return Data
