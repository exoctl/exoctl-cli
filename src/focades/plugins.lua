local Log    = require("src.log")
local cjson    = require("cjson")

local Plugins   = {
    Plugins = nil,
    Args = nil
}

Plugins.__index = Plugins


function Plugins:new()
    return setmetatable({}, Plugins)
end

function Plugins:setup(plugins, args)
    self.Plugins = plugins
    self.Args = args
end

function Plugins:plugins()
    local headers, body = self.Plugins:plugins()

    if headers and headers:get(":status") == "200" then
        local function recursive_json_to_string(json, depth)
            local result = ""
            local indent = string.rep("  ", depth)

            for key, value in pairs(json) do
                if type(value) == "table" then
                    result = result .. indent .. key .. ":\n" .. recursive_json_to_string(value, depth + 1) .. "\n"
                else
                    result = result .. indent .. key .. " : " .. tostring(value) .. "\n"
                end
            end

            return result
        end

        local response = function()
            if not self.Args.fields["json"] then
                local json = cjson.decode(body)
                return "[ Plugins List ]\n" .. recursive_json_to_string(json, 1)
            end
            return body
        end

        Log:output(response())
    else
        Log:error("Failed to retrieve plugins: Unexpected response status.")
    end
end

return Plugins