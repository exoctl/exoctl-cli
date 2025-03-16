local cjson <const>    = require("cjson")

local Config   = {
    json = nil
}

Config.__index = Config


function Config:new()
    return setmetatable({}, Config)
end

function Config:setup(file)
    local f <const> = io.open(file, "r")
    if(f) then
        local payload = f:read("*all")
        if(payload) then
            self.json = cjson.decode(payload)
        end
    end
end

return Config
