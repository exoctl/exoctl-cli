local App   = {
    config = nil,
    gateways = {
        web = {
            Requests = require("src.gateways.web.requests"),
            Data = require("src.gateways.web.data")
        }
    }
}

App.__index = App

function App:new()
    return setmetatable({}, App)
end

function App:setup(config)
    self.config = config

    self.gateways.web.Requests:setup(self.config)
    self.gateways.web.Data:setup(self.config, self.gateways.web.requests)
end

return App
