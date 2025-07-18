# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

include $(ARDUINO_CLI_MK_DIR)/dbg/inodbg.mk

arduino.renesas_uno.minima.debug	:= jlinkgdb
arduino.renesas_uno.unor4wifi.debug	:= openocdgdb

debug: $($(BOARD).debug)

.PHONY: debug
.PHONY: arduino.renesas_uno.minima.debug
.PHONY: arduino.renesas_uno.unor4wifi.debug
