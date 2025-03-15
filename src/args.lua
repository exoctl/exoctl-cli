local argparse = require("argparse")
local Log      = require("src.log")
local Version  = require("src.version")

local Args     = {
    fields = nil,
    name = "infinity-cli",
    desc = "Infinity Engine CLI",
    epilog = "For more info, see https://github.com/maldeclabs/infinity-cli"
}

Args.__index   = Args

function Args:new()
    return setmetatable({}, Args)
end

function Args:setup()
    local parser = argparse(self.name, self.desc)
        :epilog(self.epilog)

    -- Group: Config Gateway
    local gateway_group = parser:group("Gateway Configuration")
    gateway_group:option("-g --gateway", "Specify which gateway you want to use")
        :choices({ "data:metadata", "plugins", "plugins:plugin" })
    gateway_group:option("-e --endpoint", "Your plugin's endpoint on the engine"):args(2)
        :argname { "<method>", "<url>" }:choices({ "get", "post" }, 1)
    gateway_group:option("-d --data", "Data to be passed to gateway")
    gateway_group:flag("-r --raw-data", "Bring raw engine data without processing")
    gateway_group:flag("-f --file", "Specify if 'data' is a file")

    -- Version flag
    parser:flag("-v --version", "Display the current version of the script")
        :action(function()
            Log:output(("%s - v%d.%d.%d"):format(self.name, Version.major, Version.minor, Version.patch))
            os.exit(0)
        end)

    self.fields = parser:parse()
end

return Args
