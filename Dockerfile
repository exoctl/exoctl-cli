FROM ubuntu:latest

WORKDIR /app

COPY . /app/

RUN apt-get update && \
    apt-get install -y lua5.4 liblua5.4-dev luarocks libssl-dev build-essential

RUN luarocks-5.4 install --only-deps exoctlcli-scm-1.rockspec

CMD ["lua5.4", "/app/src/exoctl-cli.lua", "-h"]
