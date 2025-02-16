# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

include $(ARDUINO_CLI_MK_DIR)/dbg/inodbg.mk

OPENOCD_CFG		:= $(shell find $(ARDUINO_DIR) -name 'openocd.cfg' |\
			grep UNOWIFIR4)

OPENOCD_FLAGS		+= --file $(OPENOCD_CFG)
OPENOCD_FLAGS		+= --command 'gdb_port 2331'

MSG_OPENOCD		:= OpenOCD:

openocd: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_OPENOCD) $<
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else echo "" > .gdbinit; fi
	@$(GDBSERVER_SH) $< >> .gdbinit
	@$(TRACE32_SH) $< > target.cmm
	@openocd $(OPENOCD_FLAGS)

arduino.renesas_uno.minima.debug	:= jlink
arduino.renesas_uno.unor4wifi.debug	:= openocd

debug: $($(BOARD).debug)

.PHONY: openocd debug
.PHONY: arduino.renesas_uno.minima.debug
.PHONY: arduino.renesas_uno.unor4wifi.debug
