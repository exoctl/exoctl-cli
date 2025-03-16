local Log    = require("src.log")
local cjson    = require("cjson")

local Data   = {
    Data = nil,
    Args = nil
}

Data.__index = Data


function Data:new()
    return setmetatable({}, Data)
end

function Data:setup(data, args)
    self.Data = data
    self.Args = args
end

function Data:metadata()
    local data = function()
        local d = self.Args.fields["data"]

        if not d then
            Log:error("Missing required argument: 'data'.")
        end

        if self.Args.fields["file"] then
            local f, err <const> = io.open(d, "r")
            if not f then
                Log:error(string.format("Failed to open file '%s': %s", d, err or "Unknown error"))
            end

            local content = f:read("*all")
            f:close()
            return content
        end

        return d
    end

    local headers, body <const> = self.Data:metadata(data())

    if headers and headers:get(":status") == "200" then
        local response = function()
            if not self.Args.fields["raw_data"] then
                local json = cjson.decode(body)
                local result = ""
    
                for key, value in pairs(json) do
                    result =  result .. key .. " : " .. tostring(value) .. "\n"
                end
    
                return "[ Metadata ]\n" .. result
            end
            return body
        end
    
        Log:output(response())
    else
        Log:error("Failed to retrieve metadata: Unexpected response status.")
    end
end

return Data