package = "infinitycli"
version = "scm-1"

source = {
   url = "",
   md5 = ""
}

description = {
   summary = "This application for CLI Infinity Engine",
   homepage = "https://github.com/maldeclabs/infinity-cli",
   license = "MIT"
}

dependencies = {
   "lua <= 5.4",
   "http",
   "lua-cjson",
   "argparse"
}

build = {
   type = "builtin",
   modules = {

   }
}