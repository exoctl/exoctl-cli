local Config    = require("src.config")
local App    = require("src.app")
local Requests = require("src.gateways.web.requests")
local Data = require("src.gateways.web.data")

Config:setup("config/config.json")
App:setup(Config)

Requests:setup(Config)

Data:setup(Config, Requests)

local headers, body = Data:metadata("text")

if headers then
    print("Status:", headers:get(":status"))
    print("Body:", body)
else
    print("Request failed")
end