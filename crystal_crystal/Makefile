.PHONY: build clean start

build:
	crystal deps --production
	crystal build -o bin/server --release bin/server.cr

clean:
	rm -f bin/server

start:
	bin/server
