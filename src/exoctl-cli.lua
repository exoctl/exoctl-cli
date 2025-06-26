local Config  <const>   = require("src.config")
local App  <const>   = require("src.app")

Config:setup("config/config.json")
App:setup(Config)
App:run()