local http_request = require("http.request")
local zlib         = require("http.zlib")
local lfs          = require("lfs")
local cjson        = require("cjson")
local Version      = require("Version")

local Dump         = {
    server = {
        url                               = "https://telemetry.maldec.io/",
        agent                             = "AppSkull v1.0",
        endpoint_monitor_dump_file_info   = "/v1/monitor/dump/file/info",
        endpoint_monitor_dump_system_info = "/v1/monitor/dump/system/info",
        endpoint_monitor_alert_debug      = "/v1/monitor/alert/debug"
    }
}
Dump.__index       = Dump


function Dump:new()
    return setmetatable({}, Dump)
end

local function compress_file_contents(file_path)
    local file = io.open(file_path, "rb")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return zlib.deflate()(content, true)
end

local function gather_file_info(file_path)
    local attr = lfs.attributes(file_path)
    if not attr then return nil end

    attr.path = file_path
    return attr
end

local function gather_system_info()
    local system_info = {
        date        = os.date("%Y-%m-%d %H:%M:%S"),
        is_vm       = false,
        hypervisor  = "unknown",
        cpu         = { model = "unknown", cores = "unknown", threads = "unknown", freq = "unknown", vendor = "unknown" },
        os_name     = "unknown",
        os_version  = "unknown",
        pretty_name = "unknown",
        machine_id  = "unknown"
    }

    if package.config:sub(1, 1) ~= "\\" then -- Linux
        local file_release = io.open("/etc/os-release", "r")
        if file_release then
            for line in file_release:lines() do
                local key, value = line:match("^(.-)%s*=%s*\"(.+)\"$")
                if key and value then
                    if key == "NAME" then
                        system_info.os_name = value
                    elseif key == "VERSION" then
                        system_info.os_version = value
                    elseif key == "PRETTY_NAME" then
                        system_info.pretty_name = value
                    end
                end
            end
            file_release:close()
        end

        local file_machine = io.open("/etc/machine-id", "r")
        if file_machine then
            system_info.machine_id = file_machine:read("*a")
            file_machine:close()
        end

        local file_cpu = io.open("/proc/cpuinfo", "r")
        if file_cpu then
            for line in file_cpu:lines() do
                local key, value = line:match("^(.-)%s+:%s+(.+)$")
                if key and value then
                    if key == "model name" then
                        system_info.cpu.model = value
                    elseif key == "cpu cores" then
                        system_info.cpu.cores = value
                    elseif key == "siblings" then
                        system_info.cpu.threads = value
                    elseif key == "cpu MHz" then
                        system_info.cpu.freq = value .. " MHz"
                    elseif key == "vendor_id" then
                        system_info.cpu.vendor = value
                    elseif key == "flags" and value:match("hypervisor") then
                        system_info.is_vm = true
                    end
                end
            end
            file_cpu:close()
        end
    else -- Windows
        system_info.cpu.model = os.getenv("PROCESSOR_IDENTIFIER") or "unknown"
        system_info.cpu.cores = os.getenv("NUMBER_OF_PROCESSORS") or "unknown"
        system_info.cpu.arch  = os.getenv("PROCESSOR_ARCHITECTURE") or "unknown"
    end
    return system_info
end

local function get_stack_trace()
    return debug.traceback()
end

local function get_process_status()
    local process_info = {}

    local pid = io.open("/proc/self/status", "r")
    if pid then
        for line in pid:lines() do
            local key, value = line:match("^(.-)%s*:%s*(.+)$")
            if key and value then
                if key == "VmRSS" then
                    process_info.memory_usage = value
                elseif key == "Pid" then
                    process_info.pid = value
                elseif key == "PPid" then
                    process_info.ppid = value
                elseif key == "Uid" then
                    process_info.uid = value
                elseif key == "Name" then
                    process_info.process_name = value
                end
            end
        end
        pid:close()
    end

    return process_info
end

local function get_process_cmdline()
    local pid = io.open("/proc/self/cmdline", "r")
    if not pid then
        return false
    end

    local cmdline = pid:read("*a")
    pid:close()

    return cmdline
end


function Dump:send_file_info_to_server(file_path)
    local file_info = gather_file_info(file_path)
    if not file_info then return false end

    local request = http_request.new_from_uri(self.server.url .. self.server.endpoint_monitor_dump_file_info)
    request.headers:upsert(":method", "POST")
    request.headers:upsert("Content-Type", "application/json")
    request.headers:upsert("user-agent", self.server.agent)
    request:set_body(cjson.encode(file_info))

    local headers = request:go(1)
    return headers and headers:get(":status") == "200"
end

function Dump:send_alert_debug_to_server()
    local system_info = gather_system_info()
    local stack_trace = get_stack_trace()
    local process_info = get_process_status()

    system_info.app_version = string.format("%d.%d.%d", Version.major, Version.minor, Version.patch)
    system_info.stack_trace = stack_trace
    system_info.process_info = process_info
    system_info.cmdline = get_process_cmdline()

    local request = http_request.new_from_uri(self.server.url .. self.server.endpoint_monitor_alert_debug)
    request.headers:upsert(":method", "POST")
    request.headers:upsert("Content-Type", "application/json")
    request.headers:upsert("user-agent", self.server.agent)
    request:set_body(cjson.encode(system_info))

    local headers = request:go(1)
    return headers and headers:get(":status") == "200"
end

return Dump
