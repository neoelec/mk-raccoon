# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

OUT_LIB_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
OUT_LIB_MK_DIR		:= $(shell dirname $(OUT_LIB_MK_FILE))

VERSION			?= 0
PATCHLEVEL		?= 0
SUBLEVEL		?= 0

AR			:= $(CROSS_COMPILE)ar

SLIBRARY		:= $(BINDIR)/$(TARGET).a
DLIBRARY		:= $(BINDIR)/$(TARGET).so.$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)

# Define Messages
MSG_ARCHIVING 	:= Archiving:

output: library

library: $(SLIBRARY) $(DLIBRARY)

$(SLIBRARY): $(COBJS) $(CXXOBJS)
	@echo
	@echo $(MSG_ARCHIVING) $@
	$(AR) rcs $@ $^

$(DLIBRARY): $(COBJS) $(CXXOBJS)
	@echo
	@echo $(MSG_LINKING) $@
	$(LD) -shared -fPIC -Wl,-soname,$(TARGET).so.$(VERSION) -o $@ $^
	ln -fs $(shell basename $@) $(BINDIR)/$(TARGET).so.$(VERSION)
	ln -fs $(shell basename $@) $(BINDIR)/$(TARGET).so
