local Log = require("src.log")

local App = {
    Config = nil,
    Args = require("src.args"),
    gateways = {
        web = {
            Requests = require("src.gateways.web.requests"),
            Data = require("src.gateways.web.data")
        }
    },
    focades = { Data = require("src.focades.data") }
}

App.__index = App

function App:new()
    return setmetatable({}, App)
end

function App:setup(config)
    self.Config = config

    local success, err = pcall(function()
        self.gateways.web.Requests:setup(self.Config)
        self.gateways.web.Data:setup(self.Config, self.gateways.web.Requests)
        self.Args:setup()
        
        self.focades.Data:setup(self.gateways.web.Data, self.Args)
    end)

    if not success then
        Log:error("Failed to initialize components: " .. err)
    end
end

function App:run()
    if not self.Args.fields["gateway"] then
        Log:error("Missing required argument: 'gateway'.")
    end

    if self.Args.fields["gateway"] == "data:metadata" then
        self.focades.Data:metadata()
    else
        Log:error(string.format("Unknown gateway: '%s'", self.Args.fields["gateway"]))
    end
end

return App
