local Plugins   = {
    config = nil,
    endpoints = { plugins = nil },
    requests = nil
}

Plugins.__index = Plugins

function Plugins:new()
    return setmetatable({}, Plugins)
end

function Plugins:setup(config, requests)
    self.config = config
    self.requests = requests
    self.endpoints.plugins = self.config.json["api"]["gateways"]["web"]["plugins"]
end

function Plugins:plugins(plugins)
    return self.requests:get(self.endpoints.plugins, plugins, "text/plain")
end

return Plugins