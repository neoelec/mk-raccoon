# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

RUST_GDB_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
RUST_GDB_PATH		:= $(shell dirname $(RUST_GDB_MK_FILE))

RUST_GDB		:= rust-gdb
RUST_GDB_FLAGS		:=

MSG_RUST_GDB		:= RUST GDB Native:

rust_gdb: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_RUST_GDB) $(OUTPUT)
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else echo "" > .gdbinit; fi
	@$(RUST_GDB_PATH)/gdb.sh $< $(TESTFLAGS) >> .gdbinit
	@$(RUST_GDB) $(RUST_GDB_FLAGS)

clean: clean_rust_gdb

clean_rust_gdb:
	$(REMOVE) .gdbinit

.PHONY: rust_gdb clean_rust_gdb
