# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

RUST_NATIVE_MK_FILE	:= $(realpath $(lastword $(MAKEFILE_LIST)))
RUST_NATIVE_MK_DIR	:= $(shell dirname $(RUST_NATIVE_MK_FILE))

include $(RUST_NATIVE_MK_DIR)/mk/base_rust.mk
include $(RUST_NATIVE_MK_DIR)/dbg/rust_gdb.mk
include $(RUST_NATIVE_MK_DIR)/dbg/gdbserver.mk
