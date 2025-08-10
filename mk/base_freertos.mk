# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

BASE_FREERTOS_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
BASE_FREERTOS_MK_DIR	:= $(shell dirname $(BASE_FREERTOS_MK_FILE))

VPATH			+= $(FREERTOS_KERNEL_DIR)
VPATH			+= $(FREERTOS_KERNEL_DIR)/portable/MemMang
EXTRAINCDIRS		+= $(FREERTOS_KERNEL_DIR)/include

include $(BASE_FREERTOS_MK_DIR)/freertos/$(FREERTOS_VERSION).mk
