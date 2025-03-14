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

function Plugins:plugins()
    return self.requests:get(self.endpoints.plugins)
end

function Plugins:plugin(plugin_url, req)
    if req["method"] == "get" then
        return self.requests:get(plugin_url)
    elseif req["method"] == "post"  then
        return self.requests:post(plugin_url, req["content"], req["content_type"])
    end
end

return Plugins