# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

BASE_CMSIS_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
BASE_CMSIS_MK_DIR	:= $(shell dirname $(BASE_CMSIS_MK_FILE))

EXTRAINCDIRS		+= $(CMSIS_DIR)/CMSIS/Core/Include

VPATH			+= $(CMSIS_DIR)/CMSIS/RTOS2/Source
EXTRAINCDIRS		+= $(CMSIS_DIR)/CMSIS/RTOS2/Template
EXTRAINCDIRS		+= $(CMSIS_DIR)/CMSIS/RTOS2/Include
