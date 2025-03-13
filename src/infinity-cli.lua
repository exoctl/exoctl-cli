local Config    = require("src.config")
local App    = require("src.app")
local Requests = require("src.gateways.web.requests")

Config:setup("config/config.json")
App:setup(Config)
Requests:setup(Config)