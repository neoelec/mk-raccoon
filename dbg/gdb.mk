# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GDB_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
GDB_PATH		:= $(shell dirname $(GDB_MK_FILE))

GDB			?= gdb
GDB_FLAGS		+=

MSG_GDB			:= GDB Native:

gdb: $(OUTPUT) $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_GDB) $(OUTPUT)
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else echo "" > .gdbinit; fi
	@$(GDB_PATH)/gdb.sh $< $(TESTFLAGS) >> .gdbinit
	@$(GDB) $(GDB_FLAGS)

clean: clean_gdb

clean_gdb:
	$(REMOVE) .gdbinit

.PHONY: gdb clean_gdb
