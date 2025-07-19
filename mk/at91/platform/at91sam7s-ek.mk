# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

CHIP			:= at91sam7s256

VPATH			+= $(AT91LIB)/boards/$(BOARD)
VPATH			+= $(AT91LIB)/boards/$(PLATFORM)

EXTRAINCDIRS		+= $(AT91LIB)/boards/$(BOARD)
EXTRAINCDIRS		+= $(AT91LIB)/boards/$(PLATFORM)

CSRCS			+= board_lowlevel.c
CSRCS			+= board_memories.c

ASRCS			+= board_cstartup.S

CFLAGS			+= -Dflash
CFLAGS			+= -mcpu=arm7tdmi
CFLAGS			+= -mfloat-abi=soft

# Linker Script
LD_SCRIPT		?= $(AT91LIB)/boards/$(PLATFORM)/$(CHIP)/flash.lds

include $(AT91LIB)/boards/$(PLATFORM)/board.mak
