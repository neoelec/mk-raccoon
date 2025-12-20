# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GCC_AT91_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
GCC_AT91_MK_DIR		:= $(shell dirname $(GCC_AT91_MK_FILE))

# Chip & board used for compilation
# (can be overriden by adding CHIP=chip and BOARD=board to the command-line)
BOARD			?= at91sam7s-ek
PLATFORM		?= at91sam7s-ek

include $(GCC_AT91_MK_DIR)/mk/at91/platform/$(PLATFORM).mk

# Trace level used for compilation
# (can be overriden by adding TRACE_LEVEL=#number to the command-line)
# TRACE_LEVEL_DEBUG      5
# TRACE_LEVEL_INFO       4
# TRACE_LEVEL_WARNING    3
# TRACE_LEVEL_ERROR      2
# TRACE_LEVEL_FATAL      1
# TRACE_LEVEL_NO_TRACE   0
TRACE_LEVEL		?= 0

CROSS_COMPILE		:= arm-none-eabi-

# Output directories
BINDIR			:= bin
OBJDIR			:= obj

# Append OBJ and BIN directories to output filename
OUTPUT			:= $(addprefix $(BINDIR)/, $(TARGET)-$(BOARD)-$(CHIP))

VPATH			+= $(AT91LIB)/utility

EXTRAINCDIRS		+= $(AT91LIB)

CSRCS			+=
ASRCS			+=

#---------------- Compiler Options ----------------
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing
CFLAGS			+= -D$(CHIP)
CFLAGS			+= -DTRACE_LEVEL=$(TRACE_LEVEL)
CFLAGS			+= -mlong-calls
CFLAGS			+= -ffunction-sections
CFLAGS			+= --param=min-pagesize=0

#---------------- Assembler Options ----------------
#  -Wa,...:   tell GCC to pass this to the assembler.
#  -ahlms:    create listing
#  -gstabs:   have the assembler create line number information; note that
#             for use in COFF files, additional information about filenames
#             and function names needs to be present in the assembler source
#             files [FIXME: not yet described there]
#  -listing-cont-lines: Sets the maximum number of continuation lines of hex
#       dump that will be displayed for a given single line of source input.
ASFLAGS			+= -D__ASSEMBLY__

#---------------- Linker Options ----------------
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS			+= -T"$(LD_SCRIPT)"
LDFLAGS			+= -nostartfiles
LDFLAGS			+= -Wl,--gc-sections
LDFLAGS			+= -static
LDFLAGS			+= -Wl,--start-group -lc -lm -Wl,--end-group

include $(GCC_AT91_MK_DIR)/mk/base_cc.mk

JLINK_CHIP		:= $(shell echo $(CHIP) | tr a-z A-Z)
JFLASH_PRJ		:= $(GCC_AT91_MK_DIR)/mk/at91/jflash/$(CHIP).jflash

include $(GCC_AT91_MK_DIR)/dbg/jlink.mk
