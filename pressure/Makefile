default: build
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | sort | awk -F ':.*##' '{printf "%-12s\t%s\n",$$1,$$2}'

bin/pressure: build
.PHONY: build
build: ## Build a release binary
	crystal deps --production
	crystal build --release -o bin/pressure bin/pressure.cr

.PHONY: clean
clean: ## Clean
	rm -f bin/pressure

.PHONY: fix
fix: ## Fix lint automatically
	find bin src spec -type f -name '*.cr' -exec crystal tool format {} \;

.PHONY: pressure
pressure: bin/pressure ## Benchmark
	./pressure.sh

.PHONY: test
test: ## Test
	find bin src spec -name '*.cr' -exec crystal tool format --check {} \;
	crystal spec
