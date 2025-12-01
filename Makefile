.PHONY: all test luacheck stylua

all: tests

tests: luacheck stylua

luacheck:
	luacheck lua

stylua:
	stylua lua --check
