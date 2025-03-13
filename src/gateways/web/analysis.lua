local Analysis   = {
    config = nil
}

Analysis.__index = Analysis

function Analysis:new()
    return setmetatable({}, Analysis)
end

function Analysis:setup(config)
    self.config = config
end

return Analysis