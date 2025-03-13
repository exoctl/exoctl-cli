local App   = {
    config = nil
}

App.__index = App

function App:new()
    return setmetatable({}, App)
end

function App:setup(config)
    self.config = config
end

return App
