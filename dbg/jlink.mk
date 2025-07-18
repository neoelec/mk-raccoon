# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

JLINK_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
JLINK_MK_DIR		:= $(shell dirname $(JLINK_MK_FILE))

JLINKBIN		:= /opt/SEGGER/JLink

JFLASHEXE		:= $(JLINKBIN)/JFlashExe
JLINKGDBEXE		:= $(JLINKBIN)/JLinkGDBServerCLExe

JLINKCHIP		?= AT91SAM7S256
JLINKPORT		?= 2331

JFLASHFLAGS		+= -auto
JFLASHFLAGS		+= -startapp
JFLASHFLAGS		+= -exit
JFLASHFLAGS		+= -hide

JLINKGDBFLAGS		+= -device $(JLINKCHIP)
JLINKGDBFLAGS		+= -noir
JLINKGDBFLAGS		+= -noLocalhostOnly
JLINKGDBFLAGS		+= -nologtofile
JLINKGDBFLAGS		+= -port $(JLINKPORT)

GDBSERVER_SH		?= $(JLINK_MK_DIR)/gdbserver.sh
TRACE32_SH		?= $(JLINK_MK_DIR)/t32_jlink.sh

DEBUG_SYMBOL		:= $(OUTPUT).elf

MSG_JFLASH		:= J-Flash:
MSG_JLINKGDB		:= J-Link GDB:

USE_JFLASH		?= y

ifeq ($(USE_JFLASH),y)
jflash: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_JFLASH) $<
	$(JFLASHEXE) -open $< -openprj $(JFLASHPRJ) $(JFLASHFLAGS)

.PHONY: jflash
endif

jlinkgdb: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_JLINKGDB) $<
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else echo "" > .gdbinit; fi
	@$(GDBSERVER_SH) $< >> .gdbinit
	@$(TRACE32_SH) $< > target.cmm
	$(JLINKGDBEXE) $(JLINKGDBFLAGS)

clean: clean_jlinkgdb

clean_jlinkgdb:
	$(REMOVE) .gdbinit
	$(REMOVE) target.cmm

.PHONY: jlinkgdb clean_jlinkgdb
