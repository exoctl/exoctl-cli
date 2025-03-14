local argparse = require "argparse"

local Args     = {
    fields = nil
}

Args.__index   = Args

function Args:new()
    return setmetatable({}, Args)
end

function Args:setup()
    local parser = argparse():name("infinity-cli"):description("Infinity Engine CLI"):epilog(
        "For more info, see https://github.com/maldeclabs/infinity-cli")
    parser:option("-g --gateway", "specify which gateway you want to use")
        :choices({ "data:metadata", "plugins", "plugins:plugin" })
    parser:option("-e --endpoint", "your plugin's endpoint on the engine")
    parser:option("-d --data", "data to be passed to gateway")
    parser:flag("-r --raw-data", "bring raw engine data without processing")
    parser:flag("-f --file", "specify if 'data' is a file")

    self.fields = parser:parse()
end

return Args
