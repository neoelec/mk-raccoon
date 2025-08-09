# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GDBSERVER_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
GDBSERVER_PATH		:= $(shell dirname $(GDBSERVER_MK_FILE))

GDBSERVER		:= gdbserver
GDBSERVER_PORT		?= 2331

GDBSERVER_FLAGS		:= localhost:$(GDBSERVER_PORT) $(OUTPUT)

GDBSERVER_SH		?= $(GDBSERVER_PATH)/gdbserver.sh
TRACE32_SH		?= $(GDBSERVER_PATH)/t32_native.sh

DEBUG_SYMBOL		:= $(OUTPUT).elf

MSG_GDBSERVER		:= GDB Server:

gdbserver: $(OUTPUT) $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_GDBSERVER) $(OUTPUT)
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else echo "" > .gdbinit; fi
	@$(GDBSERVER_SH) $< >> .gdbinit
	@$(TRACE32_SH) $< > target.cmm
	@$(GDBSERVER) $(GDBSERVER_FLAGS) $(TESTFLAGS)

clean: clean_gdbserver

clean_gdbserver:
	$(REMOVE) .gdbinit
	$(REMOVE) target.cmm

.PHONY: gdbserver clean_gdbserver
