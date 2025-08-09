# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

LLVM_NATIVE_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
LLVM_NATIVE_MK_DIR	:= $(shell dirname $(LLVM_NATIVE_MK_FILE))

include $(LLVM_NATIVE_MK_DIR)/mk/base_llvm.mk
include $(LLVM_NATIVE_MK_DIR)/dbg/gdb.mk
include $(LLVM_NATIVE_MK_DIR)/dbg/gdbserver.mk

all: $(OUTPUT)

$(OUTPUT): $(ELF_FILE)
	@$(COPY) $< $@

run: $(OUTPUT)
	$< $(TESTFLAGS)

clean: clean_native

clean_native:
	$(REMOVE) $(OUTPUT)

.PHONY: run clean_native
