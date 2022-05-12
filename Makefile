.PHONY: build
build:
	@swift build

.PHONY: run
run:
	@(MAKE) build
	@swift run
	@xed .

.PHONY: test_build
test:
	@(MAKE) build
	@swift test

.PHONY: test_without_build
	@swift test

