# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

LLVM_NATIVE_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
LLVM_NATIVE_MK_DIR	:= $(shell dirname $(LLVM_NATIVE_MK_FILE))

CC			:= clang
CXX			:= clang++
OBJCOPY			:= llvm-objcopy
OBJDUMP			:= llvm-objdump
SIZE			:= llvm-size
STRIP			:= llvm-strip
NM			:= llvm-nm

LDFLAGS			+= -fuse-ld=lld -flto

include $(LLVM_NATIVE_MK_DIR)/mk/base_cc.mk
include $(LLVM_NATIVE_MK_DIR)/dbg/gdb.mk

all: $(OUTPUT)

$(OUTPUT): $(ELF_FILE)
	@$(COPY) $< $@
	@$(STRIP) $@

run: $(OUTPUT)
	$< $(TESTFLAGS)

clean: clean_native

clean_native:
	$(REMOVE) $(OUTPUT)

.PHONY: run clean_native
