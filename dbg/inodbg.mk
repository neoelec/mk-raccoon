# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

INODBG_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
INODBG_MK_DIR		:= $(shell dirname $(INODBG_MK_FILE))

TRACE32_SH		:= $(INODBG_MK_DIR)/t32_inodbg.sh

# forcley disable jflash
USE_JFLASH		:= n

include $(INODBG_MK_DIR)/jlink.mk
