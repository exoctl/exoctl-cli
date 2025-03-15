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
    local parser = argparse():name(self.name):description(self.desc):epilog(self.epilog)

    parser:option("-g --gateway", "specify which gateway you want to use")
        :choices({ "data:metadata", "plugins", "plugins:plugin" })
    parser:option("-e --endpoint", "your plugin's endpoint on the engine")
    parser:option("-d --data", "data to be passed to gateway")
    parser:flag("-r --raw-data", "bring raw engine data without processing")
    parser:flag("-f --file", "specify if 'data' is a file")
    parser:flag("-v --version", "Display the current version of the script")
        :action(function()
            Log:output(("%s - v%d.%d.%d"):format(self.name, Version.major, Version.minor, Version.patch))
            os.exit(0)
        end)


    self.fields = parser:parse()
end

return Args
