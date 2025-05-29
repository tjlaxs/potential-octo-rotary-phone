test:
	@lua tests.lua

check_fails:
	@lua fails.lua --all-fail
