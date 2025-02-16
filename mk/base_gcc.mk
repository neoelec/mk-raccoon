# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

BASE_GCC_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
BASE_GCC_MK_DIR		:= $(shell dirname $(BASE_GCC_MK_FILE))

# Cross compile
CROSS_COMPILE		?=

# Target file name (without extension).
TARGET			?=

# Output directories
BINDIR			?= bin
OBJDIR			?= obj

# Define output file
OUTPUT			?= $(addprefix $(BINDIR)/, $(TARGET))

# Optimization level, can be [0, 1, 2, 3, s].
#     0 = turn off optimization. s = optimize for size.
#     (Note: 3 is not always the best optimization level.)
OPT			?= s

# Debugging format.
DEBUG			?=

# Compiler flag to set the C Standard level.
#     c89   = "ANSI" C
#     gnu89 = c89 plus GCC extensions
#     c99   = ISO C99 standard (not yet fully implemented)
#     gnu99 = c99 plus GCC extensions
CSTANDARD		?= -std=gnu17
CXXSTANDARD		?= -std=gnu++17

# Makefile for assembler
AS_MK			?= $(BASE_GCC_MK_DIR)/as_gas.mk

# Makefile for output
OUT_MK			?= $(BASE_GCC_MK_DIR)/out_elf.mk

# Source extension names
EXT_CC			+= c
EXT_CXX			+= cc cpp
EXT_AS			+= asm S

# VPATH variable
VPATH			+=

# List C source files here.
CSRCS			+=

# List C++ source files here.
CXXSRCS			+=

# List Assembler source files here.
#     Make them always end in a capital .S.  Files ending in a lowercase .s
#     will not be considered source files but generated files (assembler
#     output from the compiler), and will be deleted upon "make clean"!
#     Even though the DOS/Win* filesystem matches both .s and .S the same,
#     it will preserve the spelling of the filenames, and gcc itself does
#     care about how the name is spelled on its command-line.
ASRCS			+=

# List any extra directories to look for include files here.
#     Each directory must be seperated by a space.
#     Use forward slashes for directory separators.
#     For a directory that has spaces, enclose it in quotes.
EXTRAINCDIRS		+=

# Place -D or -U options here
CDEFS			+=

# Place -I options here
CINCS			+=

#---------------- Compiler Options ----------------
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing
CFLAGS			+= -Wall
CFLAGS			+= -g$(DEBUG)
CFLAGS			+= $(CDEFS) $(CINCS)
CFLAGS			+= -O$(OPT)
CFLAGS			+= $(patsubst %,-I%,$(EXTRAINCDIRS))

CONLYFLAGS		+= $(CSTANDARD)

#---------------- C++ Compiler Options ----------------
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing
CXXFLAGS		+= $(CXXSTANDARD)

#---------------- Assembler Options ----------------
#  -Wa,...:   tell GCC to pass this to the assembler.
#  -ahlms:    create listing
#  -gstabs:   have the assembler create line number information; note that
#             for use in COFF files, additional information about filenames
#             and function names needs to be present in the assembler source
#             files [FIXME: not yet described there]
#  -listing-cont-lines: Sets the maximum number of continuation lines of hex
#       dump that will be displayed for a given single line of source input.
ASFLAGS			+=

#---------------- Linker Options ----------------
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS			+= -Wl,-Map=$(OUTPUT).map,--cref

#============================================================================

# Define programs and commands.
CC			:= $(CROSS_COMPILE)gcc
CXX			:= $(CROSS_COMPILE)g++
LD			:= $(CROSS_COMPILE)g++
OBJCOPY			:= $(CROSS_COMPILE)objcopy
OBJDUMP			:= $(CROSS_COMPILE)objdump
SIZE			:= $(CROSS_COMPILE)size
STRIP			:= $(CROSS_COMPILE)strip
NM			:= $(CROSS_COMPILE)nm
REMOVE			:= rm -rf
COPY			:= cp

# Define Messages
# English
MSG_SIZE_BEFORE		:= Size before:
MSG_SIZE_AFTER		:= Size after:
MSG_EXTENDED_LISTING	:= Creating Extended Listing:
MSG_SYMBOL_TABLE	:= Creating Symbol Table:
MSG_LINKING		:= Linking:
MSG_COMPILING		:= Compiling:
MSG_ASSEMBLING		:= Assembling:
MSG_CLEANING		:= Cleaning project:

# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_CFLAGS		:= $(CFLAGS) $(CONLYFLAGS)
ALL_CXXFLAGS		:= $(CFLAGS) $(CXXFLAGS)
ALL_ASFLAGS		:= $(CFLAGS) $(ASFLAGS)
ALL_LDFLAGS		:= $(CFLAGS) $(LDFLAGS)

# Default target.
all: build

build: gccversion sizebefore $(BINDIR) $(OBJDIR) output sizeafter

$(BINDIR) $(OBJDIR):
	@mkdir -p $@

# Display size of file.
sizebefore: | gccversion
	@if [ -f $(OUTPUT).elf ]; then \
		echo; \
		echo $(MSG_SIZE_BEFORE); \
		$(SIZE) --format=berkeley --radix=10 $(OUTPUT).elf 2>/dev/null; \
		echo; \
	fi

sizeafter: | output
	@if [ -f $(OUTPUT).elf ]; then \
		echo; \
		echo $(MSG_SIZE_AFTER); \
		$(SIZE) --format=berkeley --radix=10 $(OUTPUT).elf 2>/dev/null; \
		echo; \
	fi

# Display compiler version information.
gccversion:
	@$(CC) --version

# Compile: create object files from C source files.
define RULES_CC
COBJS_$(1)		:= $(addprefix $(OBJDIR)/,\
	$(patsubst %.$(1),%.o,$(filter %.$(1),$(CSRCS))))
COBJS			+= $$(COBJS_$(1))
$$(COBJS_$(1)): $(OBJDIR)/%.o : %.$(1) | $(OBJDIR)
	@echo
	@echo $(MSG_COMPILING) $$<
	$(CC) -c -Wa,-adhlns=$$(@:.o=.lst) $(ALL_CFLAGS) $$< -o $$@
endef

$(foreach EXT, $(EXT_CC), $(eval $(call RULES_CC,$(EXT))))

# Compile: create object files from C++ source files.
define RULES_CXX
CXXOBJS_$(1)		:= $(addprefix $(OBJDIR)/,\
	$(patsubst %.$(1),%.o,$(filter %.$(1),$(CXXSRCS))))
CXXOBJS			+= $$(CXXOBJS_$(1))
$$(CXXOBJS_$(1)): $(OBJDIR)/%.o : %.$(1) | $(OBJDIR)
	@echo
	@echo $(MSG_COMPILING) $$<
	$(CXX) -c -Wa,-adhlns=$$(@:.o=.lst) $(ALL_CXXFLAGS) $$< -o $$@
endef

$(foreach EXT, $(EXT_CXX), $(eval $(call RULES_CXX,$(EXT))))

-include $(AS_MK)
-include $(OUT_MK)

# Target: clean project.
clean: clean_list

clean_list:
	@echo
	@echo $(MSG_CLEANING)
	$(REMOVE) $(OBJDIR)
	$(REMOVE) $(BINDIR)

# Listing of phony targets.
.PHONY: all sizebefore sizeafter gccversion \
		build elf lss sym \
		clean clean_list
