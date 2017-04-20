.PHONY: build clean start

build:
	yarn
	node_modules/.bin/coffee -c -o . index.coffee

clean:
	rm -f index.js

start:
	node index.js
