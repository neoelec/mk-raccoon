# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GCC_LIBRARY_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
GCC_LIBRARY_MK_DIR	:= $(shell dirname $(GCC_LIBRARY_MK_FILE))

OUT_MK			:= $(GCC_LIBRARY_MK_DIR)/mk/out_lib.mk

include $(GCC_LIBRARY_MK_DIR)/mk/base_cc.mk

.PHONY: exec run clean_native
