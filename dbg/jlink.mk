# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

JLINK_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
JLINK_MK_DIR		:= $(shell dirname $(JLINK_MK_FILE))

JLINK_DIR		:= /opt/SEGGER/JLink

JFLASH			:= $(JLINK_DIR)/JFlashExe
JLINKGDB		:= $(JLINK_DIR)/JLinkGDBServerCLExe

JLINK_CHIP		?= AT91SAM7S256
JLINK_PORT		?= 2331

JFLASH_FLAGS		+= -auto
JFLASH_FLAGS		+= -startapp
JFLASH_FLAGS		+= -exit
JFLASH_FLAGS		+= -hide

JLINKGDB_FLAGS		+= -device $(JLINK_CHIP)
JLINKGDB_FLAGS		+= -noir
JLINKGDB_FLAGS		+= -noLocalhostOnly
JLINKGDB_FLAGS		+= -nologtofile
JLINKGDB_FLAGS		+= -port $(JLINK_PORT)

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
	$(JFLASH) -open $< -openprj $(JFLASH_PRJ) $(JFLASH_FLAGS)

.PHONY: jflash
endif

jlinkgdb: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_JLINKGDB) $<
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else echo "" > .gdbinit; fi
	@$(GDBSERVER_SH) $< >> .gdbinit
	@$(TRACE32_SH) $< > target.cmm
	$(JLINKGDB) $(JLINKGDB_FLAGS)

clean: clean_jlinkgdb

clean_jlinkgdb:
	$(REMOVE) .gdbinit
	$(REMOVE) target.cmm

.PHONY: jlinkgdb clean_jlinkgdb
