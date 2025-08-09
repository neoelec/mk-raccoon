# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GCC_NATIVE_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
GCC_NATIVE_MK_DIR	:= $(shell dirname $(GCC_NATIVE_MK_FILE))

include $(GCC_NATIVE_MK_DIR)/mk/base_gcc.mk
include $(GCC_NATIVE_MK_DIR)/dbg/gdb.mk
include $(GCC_NATIVE_MK_DIR)/dbg/gdbserver.mk

all: $(OUTPUT)

$(OUTPUT): $(ELF_FILE)
	@$(COPY) $< $@

run: $(OUTPUT)
	$< $(TESTFLAGS)

clean: clean_native

clean_native:
	$(REMOVE) $(OUTPUT)

.PHONY: run clean_native
