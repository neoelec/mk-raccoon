# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

OPENOCD_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
OPENOCD_MK_DIR		:= $(shell dirname $(OPENOCD_MK_FILE))

OPENOCD			:= openocd

OPENOCDPORT		?= 2331

OPENOCDFLASHFLAGS	+= $(OPENOCDFLAGS)

OPENOCDGDBFLAGS		+= $(OPENOCDFLAGS)
OPENOCDGDBFLAGS		+= --command "gdb_port $(OPENOCDPORT)"

GDBSERVER_SH		?= $(OPENOCD_MK_DIR)/gdbserver.sh
TRACE32_SH		?= $(OPENOCD_MK_DIR)/t32_jlink.sh

DEBUG_SYMBOL		:= $(OUTPUT).elf

MSG_OPENOCDFLASH	:= OpenOCD Flash:
MSG_OPENOCDGDB		:= OpenOCD GDB:

USE_OPENOCDFLASH	?= y

ifeq ($(USE_OPENOCDFLASH),y)
openocdflash: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_OPENOCDFLASH) $<
	$(OPENOCD) --file $(OPENOCDCFG) $(OPENOCDFLASHFLAGS) \
			--command "program $< verify reset exit"

.PHONY: openocdflash
endif

openocdgdb: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_OPENOCDGDB) $<
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else echo "" > .gdbinit; fi
	@$(GDBSERVER_SH) $< >> .gdbinit
	@$(TRACE32_SH) $< > target.cmm
	$(OPENOCD) --file $(OPENOCDCFG) $(OPENOCDGDBFLAGS)

clean: clean_openocdgdb

clean_openocdgdb:
	$(REMOVE) .gdbinit
	$(REMOVE) target.cmm

.PHONY: openocdgdb clean_openocdgdb
