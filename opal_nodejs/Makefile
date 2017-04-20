.PHONY: build clean start

build:
	bundle
	bundle exec opal -c index.rb > index.js

clean:
	rm -f index.js

start:
	node index.js
