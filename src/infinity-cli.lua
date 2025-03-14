local Config    = require("src.config")
local App    = require("src.app")

Config:setup("config/config.json")
App:setup(Config)
App:run()