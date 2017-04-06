default: build
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | sort | awk -F ':.*##' '{printf "%-12s\t%s\n",$$1,$$2}'

.PHONY: build
build: ## Build.
	yarn
	node_modules/.bin/webpack

.PHONY: clean
clean: ## Clean built resources.
	rm -f index.js

.PHONY: start
start: ## Start an app.
	node .

.PHONY: test
test: ## Test.
	node_modules/.bin/eslint src
	node_modules/.bin/flow src
