local Requests = require("src.gateways.web.requests")
local Data = require("src.gateways.web.data")

local App   = {
    config = nil
}

App.__index = App

function App:new()
    return setmetatable({}, App)
end

function App:setup(config)
    self.config = config
    
    Requests:setup(self.config)
    Data:setup(self.config, Requests)
end

return App
