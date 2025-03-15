# Infinity-cli

![assets/banner](assets/banner.png)

An easy way to interact with your engine using our CLI

## Installation

lua5.4 and luarocks5.4 required to install dependencies

```sh
$ sudo luarocks-5.4 install --only-deps infinitycli-scm-1.rockspec
```

## Basic usage

You can take a more detailed look at the docs on [gitbook](https://maldecs-organization.gitbook.io/maldeclabs/getting-started/basic-usage)

```sh
$ lua src/infinity-cli.lua -h
Usage: infinity-cli [-h] [-g {data:metadata,plugins,plugins:plugin}]
       [-m {get,post}] [-e <endpoint>] [-d <data>] [-r] [-f] [-v]

Infinity Engine CLI

Options:
   -h, --help            Show this help message and exit.
          -g {data:metadata,plugins,plugins:plugin},
   --gateway {data:metadata,plugins,plugins:plugin}
                         Specify which gateway you want to use
         -m {get,post},  Your plugin's endpoint method on the engine
   --method {get,post}
           -e <endpoint>,
   --endpoint <endpoint>
                         Your plugin's endpoint on the engine
       -d <data>,        Data to be passed to gateway
   --data <data>
   -r, --raw-data        Bring raw engine data without processing
   -f, --file            Specify if 'data' is a file
   -v, --version         Display the current version of the script

For more info, see https://github.com/maldeclabs/infinity-cli

```

You can view the plugins your engine uses

```sh
$ lua src/infinity-cli.lua -g plugins
[ Plugins List ]
  lua:
    state_memory : 0x47c2f
    scripts:
      1:
        name : example.lua
        path : plugins/example.lua
        type : file
```

Send data to metadata

```sh
$ lua src/infinity-cli.lua -g data:metadata -d "Why do programmers prefer dark mode? Because light attracts bugs!"
[ Metadata ]
mime_type : text/plain; charset=us-ascii
sha384 : 9b1ee54e14080dbbbd417950606de168500747257755564c6d67483d7d5d2361b3b5faed2d0e4535189c5464da0b0f6e
entropy : 4.2020635829546
sha3_256 : 164d7d5c98a14839cc04dfbec14672b59130d35d5136f94f344c75f7970f794a
sha3_512 : 633a7d1a2f286e9b1175534aa03c74409acc1ea90d2ea75cbe9b161f65cac0c0f0c2cb22d5df2c46cada3cbd87a56fe2d0afae34c692d0886088ec8222c0bfd5
sha224 : 699b2227773b709b35a6c11d1d07d6b9c730789f38ce88e280d0f8af
creation_date : 2025-03-14
size : 65.0
sha256 : 8e4bf126e62cf07de438599a8e043c3b998f4a59abc6cc7cde874b8118a6b015
sha1 : 608974e94107c504ed2e04cd80404e6f1f107f55
sha512 : 92ef4546765623308e1aef4682bb965bd10f60b0beef5b68bb12c8c2a0e5cfba1d7cd2c5bf213edc8890f19b0f5ca8a8e21e5509122d6e6e2e3fce50bb4e8e22
```

> [!NOTE]  
> If you want to send a file, just use the -f flag