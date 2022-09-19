# (c) 2022-Present IObundle, Lda, all rights reserved
#
# This makefile segment lists all hardware header and source files 
#
# It is always included in submodules/LIB/Makefile for populating the
# build directory
#
ifeq ($(filter UART, $(HW_MODULES)),)

#add itself to HW_MODULES list
HW_MODULES+=UART

#import lib hardware
include $(LIB_DIR)/hardware/include/hw_setup.mk
include $(LIB_DIR)/hardware/iob_reg/hw_setup.mk

UART_INC_DIR:=$(UART_DIR)/hardware/include
UART_SRC_DIR:=$(UART_DIR)/hardware/src

#HEADERS

SRC+=$(BUILD_VSRC_DIR)/iob_uart_version.vh
$(BUILD_VSRC_DIR)/iob_uart_version.vh:
	$(LIB_DIR)/scripts/version.py -v $(UART_DIR)
	mv iob_uart_version.vh $(BUILD_VSRC_DIR)

SRC+=$(subst $(UART_INC_DIR), $(BUILD_VSRC_DIR), $(wildcard $(UART_INC_DIR)/*.vh))
$(BUILD_VSRC_DIR)/%.vh: $(UART_INC_DIR)/%.vh
	cp $< $(BUILD_VSRC_DIR)

SRC+=$(BUILD_VSRC_DIR)/iob_uart_swreg_gen.vh $(BUILD_VSRC_DIR)/iob_uart_swreg_def.vh
$(BUILD_VSRC_DIR)/iob_uart_swreg_gen.vh: iob_uart_swreg_gen.vh 
	mv $< $(BUILD_VSRC_DIR)

$(BUILD_VSRC_DIR)/iob_uart_swreg_def.vh: iob_uart_swreg_def.vh
	mv $< $(BUILD_VSRC_DIR)

iob_uart_swreg_def.vh iob_uart_swreg_gen.vh: $(UART_DIR)/mkregs.conf
	$(LIB_DIR)/scripts/mkregs.py iob_uart $(UART_DIR) HW

SRC+=$(BUILD_VSRC_DIR)/iob_lib.vh

#SOURCES
SRC+=$(subst $(UART_SRC_DIR), $(BUILD_VSRC_DIR), $(wildcard $(UART_SRC_DIR)/*.v))
$(BUILD_VSRC_DIR)/%.v: $(UART_SRC_DIR)/%.v
	cp $< $(BUILD_VSRC_DIR)

endif