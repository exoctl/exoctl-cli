local argparse = require "argparse"

local Args     = {
    fields = nil
}

Args.__index   = Args

function Args:new()
    return setmetatable({}, Args)
end

function Args:setup()
    local parser = argparse("infinity-cli", "Infinity Engine CLI")
    parser:option("-g --gateway", "specify which gateway you want to use")
    parser:flag("-f --file", "specify if it is a file")

    self.fields = parser:parse()
end

return Args
