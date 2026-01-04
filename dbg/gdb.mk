# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GDB_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
GDB_PATH		:= $(shell dirname $(GDB_MK_FILE))

GDB			?= gdb
GDB_FLAGS		+=

GDBSERVER		:= gdbserver
GDBSERVER_PORT		?= 2331
GDBSERVER_FLAGS		?= localhost:$(GDBSERVER_PORT) $(DEBUG_SYMBOL)

TRACE32_MODE		?= native

MSG_GDB_LOCALHOST	:= GDB Local Host:
MSG_GDB_REMOTE		:= GDB Remote:
MSG_GDBSERVER		:= GDB Server:

gdb_localhost: $(OUTPUT) $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_GDB_LOCALHOST) $(DEBUG_SYMBOL)
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else echo "" > .gdbinit; fi
	@$(GDB_PATH)/gdb.sh localhost $(DEBUG_SYMBOL) "$(TESTFLAGS)" >> .gdbinit
	@$(GDB) $(GDB_FLAGS)

gdb_remote:
	@echo
	@echo $(MSG_GDB_REMOTE) $(DEBUG_SYMBOL)
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else echo "" > .gdbinit; fi
	@$(GDB_PATH)/gdb.sh remote $(DEBUG_SYMBOL) $(GDBSERVER_PORT) >> .gdbinit
	@$(GDB)

gdbserver: $(OUTPUT) $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_GDBSERVER) $(DEBUG_SYMBOL)
	@$(GDB_PATH)/trace32.sh $(TRACE32_MODE) $< > target.cmm
	@$(GDBSERVER) $(GDBSERVER_FLAGS) $(TESTFLAGS)

clean: clean_gdb

clean_gdb:
	$(REMOVE) .gdbinit
	$(REMOVE) target.cmm

.PHONY: gdb clean_gdb
