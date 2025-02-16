# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

ARDUINO_CLI_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
ARDUINO_CLI_MK_DIR	:= $(shell dirname $(ARDUINO_CLI_MK_FILE))

include $(ARDUINO_CLI_MK_DIR)/mk/base_arduino.mk
-include $(ARDUINO_CLI_MK_DIR)/dbg/$(BOARD_MK_FILE)
