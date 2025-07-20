# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

OPENOCDCFG		:= $(shell find $(ARDUINO_DIR) -name 'openocd.cfg' |\
			grep UNOWIFIR4)

include $(ARDUINO_CLI_MK_DIR)/dbg/inodbg.mk

arduino.renesas_uno.minima.debug	:= jlinkgdb
arduino.renesas_uno.unor4wifi.debug	:= openocdgdb

debug: $($(BOARD).debug)

.PHONY: debug
.PHONY: arduino.renesas_uno.minima.debug
.PHONY: arduino.renesas_uno.unor4wifi.debug
