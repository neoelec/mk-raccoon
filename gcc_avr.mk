# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GCC_AVR_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
GCC_AVR_MK_DIR		:= $(shell dirname $(GCC_AVR_MK_FILE))

CROSS_COMPILE		?= avr-

CC			:= $(CROSS_COMPILE)gcc
CXX			:= $(CROSS_COMPILE)g++
OBJCOPY			:= $(CROSS_COMPILE)objcopy
OBJDUMP			:= $(CROSS_COMPILE)objdump
SIZE			:= $(CROSS_COMPILE)size
STRIP			:= $(CROSS_COMPILE)strip
NM			:= $(CROSS_COMPILE)nm

# MCU name
MCU			?= atmega128

# Processor frequency.
#     This will define a symbol, F_CPU, in all source code files equal to the
#     processor frequency. You can then use this symbol in your source code to
#     calculate timings. Do NOT tack on a 'UL' at the end, this will be done
#     automatically to create a 32-bit value in your source code.
F_CPU			?= 16000000

# Output format. (can be srec, ihex, binary)
FORMAT			?= ihex

# Compiler flag to set the C Standard level.
#     c89   = "ANSI" C
#     gnu89 = c89 plus GCC extensions
#     c99   = ISO C99 standard (not yet fully implemented)
#     gnu99 = c99 plus GCC extensions
CSTANDARD		?= -std=gnu17
CXXSTANDARD		?= -std=gnu++17

# Place -D or -U options here
CDEFS			+= -mmcu=$(MCU) -DF_CPU=$(F_CPU)UL

#---------------- Compiler Options ----------------
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual and avr-libc documentation
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing
CFLAGS			+= -funsigned-char
CFLAGS			+= -funsigned-bitfields
CFLAGS			+= -fpack-struct
CFLAGS			+= -fshort-enums

#---------------- Assembler Options ----------------
#  -Wa,...:   tell GCC to pass this to the assembler.
#  -ahlms:    create listing
#  -gstabs:   have the assembler create line number information; note that
#             for use in COFF files, additional information about filenames
#             and function names needs to be present in the assembler source
#             files -- see avr-libc docs [FIXME: not yet described there]
#  -listing-cont-lines: Sets the maximum number of continuation lines of hex
#       dump that will be displayed for a given single line of source input.
ASFLAGS			+= -x assembler-with-cpp
ASFLAGS			+= -Wa,-gstabs,--listing-cont-lines=100

#---------------- External Memory Options ----------------

# 64 KB of external RAM, starting after internal RAM (ATmega128!),
# used for variables (.data/.bss) and heap (malloc()).
#EXTMEMOPTS		:= -Wl,--section-start,.data=0x801100,--defsym=__heap_end=0x80ffff

# 64 KB of external RAM, starting after internal RAM (ATmega128!),
# only used for heap (malloc()).
#EXTMEMOPTS		:= -Wl,--defsym=__heap_start=0x801100,--defsym=__heap_end=0x80ffff
EXTMEMOPTS		?=

LDFLAGS			+= $(EXTMEMOPTS)
LDFLAGS			+= -Wl,--start-group -lc -lm -Wl,--end-group

OUT_MK			:= $(GCC_AVR_MK_DIR)/mk/out_avr.mk

include $(GCC_AVR_MK_DIR)/mk/base_cc.mk
include $(GCC_AVR_MK_DIR)/dbg/avrdude.mk
