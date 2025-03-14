local App   = {
    Config = nil,
    Args = require("src.args"),
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
    self.Config = config
    self.gateways.web.Requests:setup(self.Config)
    self.gateways.web.Data:setup(self.Config, self.gateways.web.Requests)
    self.Args:setup()
end

function App:run()
    print(self.Args.fields["gateway"])
end


return App