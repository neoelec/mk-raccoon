# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

OUT_ELF_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
OUT_ELF_MK_DIR		:= $(shell dirname $(OUT_ELF_MK_FILE))

output: elf lss sym

elf: $(OUTPUT).elf
lss: $(OUTPUT).lss
sym: $(OUTPUT).sym

# Create extended listing file from ELF output file.
%.lss: %.elf
	@echo
	@echo $(MSG_EXTENDED_LISTING) $@
	$(OBJDUMP) -h -S $< > $@

# Create a symbol table from ELF output file.
%.sym: %.elf
	@echo
	@echo $(MSG_SYMBOL_TABLE) $@
	$(NM) -n $< > $@

# Link: create ELF output file from object files.
$(OUTPUT).elf: $(AOBJS) $(CXXOBJS) $(COBJS) | $(BINDIR)
	@echo
	@echo $(MSG_LINKING) $@
	$(LD) $^ -o $@ $(ALL_LDFLAGS)
