.PHONY: build clean start

build:
	MIX_ENV=prod mix do deps.get, deps.compile, compile, release

clean:
	MIX_ENV=prod mix do release.clean, clean, deps.clean --all

start:
	_build/prod/rel/ping_pong/bin/ping_pong foreground
