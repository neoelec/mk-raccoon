# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

JLINK_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
JLINK_MK_DIR		:= $(shell dirname $(JLINK_MK_FILE))

JLINKBIN		:= /opt/SEGGER/JLink

JFLASHEXE		:= $(JLINKBIN)/JFlashExe
JLINKGDBEXE		:= $(JLINKBIN)/JLinkGDBServerCLExe

JLINKCHIP		?= AT91SAM7S256
JFLASHFLAGS		:= -openprj $(JLINKBIN)/Samples/JFlash/ProjectFiles/Atmel/$(JLINKCHIP).jflash
JLINKGDBFLAGS		:= -device $(JLINKCHIP)

GDBSERVER_SH		?= $(JLINK_MK_DIR)/gdbserver.sh
TRACE32_SH		?= $(JLINK_MK_DIR)/t32_jlink.sh

DEBUG_SYMBOL		:= $(OUTPUT).elf
FLASH_BIN		:= $(OUTPUT).bin

MSG_JFLASH		:= J-Flash:
MSG_JLINK		:= J-Link:

USE_JFLASH		?= y

ifeq ($(USE_JFLASH),y)
jflash: $(FLASH_BIN)
	@echo
	@echo $(MSG_JLINK) $<
	@$(JFLASHEXE) $(JFLASHFLAGS) -open $(OUTPUT).bin,`cat $(LD_SCRIPT) | \
			grep -E '$(PROGMEM).+ORIGIN' | \
			perl -pe 's/^.+ORIGIN\s*=\s*(\S+)\s*,.+$$/$$1/'` \
		-auto -startapp -exit

.PHONY: jflash
endif

jlink: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_JLINK) $<
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else echo "" > .gdbinit; fi
	@$(GDBSERVER_SH) $< >> .gdbinit
	@$(TRACE32_SH) $< > target.cmm
	@$(JLINKGDBEXE) -select USB=0  $(JLINKGDBFLAGS) \
		-endian little -if JTAG -speed 4000 -noir -noLocalhostOnly -nologtofile \
		-port 2331 -SWOPort 2332 -TelnetPort 2333

clean: clean_jlink

clean_jlink:
	$(REMOVE) .gdbinit
	$(REMOVE) target.cmm

.PHONY: jlink clean_jlink
