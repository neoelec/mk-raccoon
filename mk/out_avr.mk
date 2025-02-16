# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

OUT_AVR_MK_FILE		:= $(realpath $(lastword $(MAKEFILE_LIST)))
OUT_AVR_MK_DIR		:= $(shell dirname $(OUT_AVR_MK_FILE))

# Define additional targets.
MSG_FLASH		:= Creating load file for Flash:
MSG_EEPROM		:= Creating load file for EEPROM:

output: hex eep

hex: $(OUTPUT).hex
eep: $(OUTPUT).eep

# Create final output files (.hex, .eep) from ELF output file.
%.hex: %.elf
	@echo
	@echo $(MSG_FLASH) $@
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

%.eep: %.elf
	@echo
	@echo $(MSG_EEPROM) $@
	$(OBJCOPY) -j .eeprom --set-section-flags .eeprom=alloc,load --change-section-lma .eeprom=0 -O $(FORMAT) $< $@

.PHONY: hex eep

include $(OUT_AVR_MK_DIR)/out_elf.mk
