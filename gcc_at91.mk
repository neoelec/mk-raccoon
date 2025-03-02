# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GCC_AT91_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
GCC_AT91_MK_DIR		:= $(shell dirname $(GCC_AT91_MK_FILE))

# Chip & board used for compilation
# (can be overriden by adding CHIP=chip and BOARD=board to the command-line)
CHIP			?= at91sam7s256
BOARD			?= at91sam7s-ek
PLATFORM		?= at91sam7s-ek
PROGMEM			?= flash

# Compile for all memories available on the board (this sets $(MEMORIES))
include $(AT91LIB)/boards/$(PLATFORM)/board.mak

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
BINDIR			:= bin/$(PROGMEM)
OBJDIR			:= obj/$(PROGMEM)

# Append OBJ and BIN directories to output filename
OUTPUT			:= $(addprefix $(BINDIR)/, $(TARGET)-$(BOARD)-$(CHIP))

VPATH			+= $(AT91LIB)/boards/$(BOARD)
VPATH			+= $(AT91LIB)/boards/$(PLATFORM)
VPATH			+= $(AT91LIB)/utility

EXTRAINCDIRS		+= $(AT91LIB)/boards/$(BOARD)
EXTRAINCDIRS		+= $(AT91LIB)/boards/$(PLATFORM)
EXTRAINCDIRS		+= $(AT91LIB)

CSRCS			+= board_lowlevel.c board_memories.c
ASRCS			+= board_cstartup.S

#---------------- Compiler Options ----------------
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing
CFLAGS			+= -D$(CHIP)
CFLAGS			+= -D$(PROGMEM)
CFLAGS			+= -DTRACE_LEVEL=$(TRACE_LEVEL)
CFLAGS			+= -Wall -mlong-calls -ffunction-sections --param=min-pagesize=0

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

#---------------- Library Options ----------------
# None pritf options
__PRINTF_LIB_NONE	:=

# Minimalistic printf version
__PRINTF_LIB_MIN	:= -Wl,-u,vfprintf -lprintf_min

# Floating point printf version (requires MATH_LIB = -lm below)
__PRINTF_LIB_FLOAT	:= -Wl,-u,vfprintf -lprintf_flt

# If this is left blank, then it will use the Standard printf version.
PRINTF_LIB		?= NONE

# None scanf options
__SCANF_LIB_NONE	:=

# Minimalistic scanf version
__SCANF_LIB_MIN		:= -Wl,-u,vfscanf -lscanf_min

# Floating point + %[ scanf version (requires MATH_LIB = -lm below)
__SCANF_LIB_FLOAT	:= -Wl,-u,vfscanf -lscanf_flt

# If this is left blank, then it will use the Standard scanf version.
SCANF_LIB		?= NONE

# Math library options
__MATH_LIB_FALSE	:=
__MATH_LIB_TRUE		:= -lm

MATH_LIB		?= FALSE

# Linker Script
LD_SCRIPT		:= $(AT91LIB)/boards/$(PLATFORM)/$(CHIP)/$(PROGMEM).lds

#---------------- Linker Options ----------------
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS			+= -T"$(LD_SCRIPT)"
LDFLAGS			+= -nostartfiles -Wl,--gc-sections
LDFLAGS			+= $(__PRINTF_LIB_$(PRINTF_LIB))
LDFLAGS			+= $(__SCANF_LIB_$(SCANF_LIB))
LDFLAGS			+= $(__MATH_LIB_$(MATH_LIB))

include $(GCC_AT91_MK_DIR)/mk/base_gcc.mk

MSG_FLASH		:= Creating load file for Flash:

bin: $(OUTPUT).bin

# Create final output files from ELF output file.
%.bin: %.elf
	@echo
	@echo $(MSG_FLASH) $@
	$(OBJCOPY) -O binary $< $@

.PHONY: elf

include $(GCC_AT91_MK_DIR)/dbg/jlink.mk
