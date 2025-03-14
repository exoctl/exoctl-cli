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
    if (self.Args.fields["gateway"] == "data:metadata") then
        local data = function()
            local d = self.Args.fields["data"]
            if (self.Args.fields["file"]) then
                local f = io.open(d, "r")
                if (f) then
                    return f:read("*all")
                else
                    error("Not possible open file '" .. d .. "'")
                end
            end

            return d
        end

        local headers, body = self.gateways.web.Data:metadata(data())

        if (headers:get(":status") == "200") then
            print(body)
        end
    end
end

return App
