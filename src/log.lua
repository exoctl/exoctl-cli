local Log   = {
    name = "infinity"
}

Log.__index = Log


function Log:new()
    return setmetatable({}, Log)
end

function Log:info(content)
    print(string.format("%s ] %s", self.name, content))
end

function Log:error(content)
    error(string.format("%s ] %s", self.name, content))
end

function Log:output(content)
    print(content)
end

return Log
