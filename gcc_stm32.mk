# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

GCC_STM32_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
GCC_STM32_MK_DIR	:= $(shell dirname $(GCC_STM32_MK_FILE))

# Chip & board used for compilation
# (can be overriden by adding CHIP=chip and BOARD=board to the command-line)
BOARD			?= nucleo-f439zi
PLATFORM		?= nucleo-f439zi

include $(GCC_STM32_MK_DIR)/mk/stm32/platform/$(PLATFORM).mk
include $(GCC_STM32_MK_DIR)/mk/stm32/series/$(SERIES).mk
include $(GCC_STM32_MK_DIR)/mk/stm32/chip/$(CHIP).mk

CROSS_COMPILE		:= arm-none-eabi-

# Output directories
BINDIR			:= bin
OBJDIR			:= obj

# Append OBJ and BIN directories to output filename
OUTPUT			:= $(addprefix $(BINDIR)/, $(TARGET)-$(BOARD)-$(CHIP))

STM32DRIVERS_DIR	:= $(STM32CUBE_DIR)/Drivers

VPATH			+= $(STM32DRIVERS_DIR)/$(SERIES)_HAL_Driver/Src
EXTRAINCDIRS		+= $(STM32DRIVERS_DIR)/$(SERIES)_HAL_Driver/Inc

VPATH			+= $(STM32DRIVERS_DIR)/CMSIS/Device/ST/$(SERIES)/Source/Templates
EXTRAINCDIRS		+= $(STM32DRIVERS_DIR)/CMSIS/Device/ST/$(SERIES)/Include

CSRCS			+=
ASRCS			+=

#---------------- Compiler Options ----------------
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing
CFLAGS			+= -DUSE_HAL_DRIVER
CFLAGS			+= -D$(SERIES)
CFLAGS			+= -D$(FAMILY)
CFLAGS			+= -ffunction-sections
CFLAGS			+= -fdata-sections
CFLAGS			+= -fstack-usage
CFLAGS			+= --specs=nano.specs

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
LDFLAGS			+= -Wl,--gc-sections
LDFLAGS			+= -static
LDFLAGS			+= -Wl,--start-group -lc -lm -Wl,--end-group

include $(GCC_STM32_MK_DIR)/mk/base_gcc.mk

OPENOCD_CFG		:= $(GCC_STM32_MK_DIR)/mk/stm32/openocd/$(CHIP).cfg

include $(GCC_STM32_MK_DIR)/dbg/openocd.mk
