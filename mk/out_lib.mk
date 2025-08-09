# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

OUT_LIB_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
OUT_LIB_MK_DIR		:= $(shell dirname $(OUT_LIB_MK_FILE))

VERSION			?= 0
PATCHLEVEL		?= 0
SUBLEVEL		?= 0

AR			:= $(CROSS_COMPILE)ar

STATIC_LIBRARY		:= $(BINDIR)/$(TARGET).a
DYNAMIC_LIBRARY		:= $(BINDIR)/$(TARGET).so.$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)

# Define Messages
MSG_ARCHIVING 	:= Archiving:

output: library

library: $(STATIC_LIBRARY) $(DYNAMIC_LIBRARY)

$(STATIC_LIBRARY): $(COBJS) $(CXXOBJS)
	@echo
	@echo $(MSG_ARCHIVING) $@
	$(AR) rcs $@ $^

$(DYNAMIC_LIBRARY): $(COBJS) $(CXXOBJS)
	@echo
	@echo $(MSG_LINKING) $@
	$(LD) -shared -fPIC -Wl,-soname,$(TARGET).so.$(VERSION) -o $@ $^
	ln -fs $(shell basename $@) $(BINDIR)/$(TARGET).so.$(VERSION)
	ln -fs $(shell basename $@) $(BINDIR)/$(TARGET).so
