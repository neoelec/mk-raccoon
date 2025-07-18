# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

AT91SAM7S_EK_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
AT91SAM7S_EK_MK_DIR	:= $(shell dirname $(AT91SAM7S_EK_MK_FILE))

CHIP			?= at91sam7s256

VPATH			+= $(AT91LIB)/boards/$(BOARD)
VPATH			+= $(AT91LIB)/boards/$(PLATFORM)

EXTRAINCDIRS		+= $(AT91LIB)/boards/$(BOARD)
EXTRAINCDIRS		+= $(AT91LIB)/boards/$(PLATFORM)

CSRCS			+= board_lowlevel.c
CSRCS			+= board_memories.c

ASRCS			+= board_cstartup.S

CFLAGS			+= -mcpu=arm7tdmi
CFLAGS			+= -mfloat-abi=soft

# Linker Script
LD_SCRIPT		?= $(AT91LIB)/boards/$(PLATFORM)/$(CHIP)/flash.lds
