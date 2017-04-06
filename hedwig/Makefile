default: build
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | sort | awk -F ':.*##' '{printf "%-12s\t%s\n",$$1,$$2}'

.PHONY: build
build: ## Build.
	MIX_ENV=prod mix do deps.get, deps.compile, compile, release

.PHONY: clean
clean: ## Clean built resources.
	MIX_ENV=prod mix do release.clean, clean, deps.clean --all

.PHONY: start
start: ## Start an app.
	_build/prod/rel/hedwig_demo/bin/hedwig_demo foreground

.PHONY: test
test: ## Test.
	mix do dogma, dialyzer
	mix test
