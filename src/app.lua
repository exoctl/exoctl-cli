local Log = require("src.log")

local App = {
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
    if not config then
        Log:error("Configuration table is required.")
    end

    self.Config = config

    local success, err = pcall(function()
        self.gateways.web.Requests:setup(self.Config)
        self.gateways.web.Data:setup(self.Config, self.gateways.web.Requests)
        self.Args:setup()
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
        local data = function()
            local d = self.Args.fields["data"]

            if not d then
                Log:error("Missing required argument: 'data'.")
            end

            if self.Args.fields["file"] then
                local f, err = io.open(d, "r")
                if not f then
                    Log:error(string.format("Failed to open file '%s': %s", d, err or "Unknown error"))
                end

                local content = f:read("*all")
                f:close()
                return content
            end

            return d
        end

        local headers, body = self.gateways.web.Data:metadata(data())

        if headers and headers:get(":status") == "200" then
            Log:output(body)
        else
            Log:error("Failed to retrieve metadata: Unexpected response status.")
        end
    else
        Log:error(string.format("Unknown gateway: '%s'", self.Args.fields["gateway"]))
    end
end

return App
