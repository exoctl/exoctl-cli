FROM ubuntu:latest

WORKDIR /app

COPY . /app/

RUN apt-get update && \
    apt-get install -y lua5.4 luarocks libssl-dev build-essential

RUN luarocks install --only-deps infinitycli-scm-1.rockspec

CMD ["lua5.4", "/app/src/infinity-cli.lua", "-h"]
