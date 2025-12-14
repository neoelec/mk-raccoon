# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

BASE_LLVM_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
BASE_LLVM_MK_DIR	:= $(shell dirname $(BASE_LLVM_MK_FILE))

# Cross compile
CROSS_COMPILE		?=

# Target file name (without extension).
TARGET			?=

# Output directories
BINDIR			?= bin
OBJDIR			?= obj

# Define output file
OUTPUT			?= $(addprefix $(BINDIR)/, $(TARGET))

# Optimization level.
OPT			?= s

# Debugging format.
DEBUG			?=

# Compiler flag to set the C Standard level.
CSTANDARD		?= -std=c17
CXXSTANDARD		?= -std=c++17

# Makefile for assembler
AS_MK			?= $(BASE_LLVM_MK_DIR)/as_cc.mk

# Makefile for output
OUT_MK			?= $(BASE_LLVM_MK_DIR)/out_elf.mk

# Source extension names
EXT_CC			+= c
EXT_CXX			+= cc cpp cxx
EXT_AS			+= asm s S

# VPATH variable
VPATH			+=

# List C source files here.
CSRCS			+=

# List C++ source files here.
CXXSRCS			+=

# List Assembler source files here.
ASRCS			+=

# List any extra directories to look for include files here.
EXTRAINCDIRS		+=

# Place -D or -U options here
CDEFS			+=

# Place -I options here
CINCS			+=

#---------------- Compiler Options ----------------
CFLAGS			+= -Wall
CFLAGS			+= -g$(DEBUG)
CFLAGS			+= $(CDEFS) $(CINCS)
CFLAGS			+= -O$(OPT)
CFLAGS			+= $(patsubst %,-I%,$(EXTRAINCDIRS))

CONLYFLAGS		+= $(CSTANDARD)

#---------------- C++ Compiler Options ----------------
CXXFLAGS		+= $(CXXSTANDARD)

#---------------- Assembler Options ----------------
ASFLAGS			+=

#---------------- Linker Options ----------------
LDFLAGS			+= -Wl,-Map=$(OUTPUT).map,--cref
LDFLAGS			+= -fuse-ld=lld -flto

#============================================================================

# Define programs and commands.
CC			:= clang
CXX			:= clang++
LD			:= clang++
OBJCOPY			:= llvm-objcopy
OBJDUMP			:= llvm-objdump
SIZE			:= llvm-size
STRIP			:= llvm-strip
NM			:= llvm-nm
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

build: llvmversion sizebefore $(BINDIR) $(OBJDIR) output sizeafter

$(BINDIR) $(OBJDIR):
	@mkdir -p $@

# Display size of file.
sizebefore: | llvmversion
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
llvmversion:
	@$(CC) --version

# Compile: create object files from C source files.
define RULES_CC
COBJS_$(1)		:= $(addprefix $(OBJDIR)/,\
	$(patsubst %.$(1),%.o,$(filter %.$(1),$(CSRCS))))
COBJS			+= $$(COBJS_$(1))
$$(COBJS_$(1)): $(OBJDIR)/%.o : %.$(1) | $(OBJDIR)
	@echo
	@echo $(MSG_COMPILING) $$<
	$(CC) -c -MMD -MP -MF$$(@:.o=.d) -MT$$@ $(ALL_CFLAGS) $$< -o $$@
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
	$(CXX) -c -MMD -MP -MF$$(@:.o=.d) -MT$$@ $(ALL_CXXFLAGS) $$< -o $$@
endef

$(foreach EXT, $(EXT_CXX), $(eval $(call RULES_CXX,$(EXT))))

-include $(AS_MK)
-include $(OUT_MK)
-include $(shell mkdir -p $(OBJDIR) 2>/dev/null) $(wildcard $(OBJDIR)/*.d)

# Target: clean project.
clean: clean_list

clean_list:
	@echo
	@echo $(MSG_CLEANING)
	$(REMOVE) $(OBJDIR)
	$(REMOVE) $(BINDIR)

# Listing of phony targets.
.PHONY: all sizebefore sizeafter llvmversion \
		build elf lss sym \
		clean clean_list
