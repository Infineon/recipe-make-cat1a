################################################################################
# \file defines.mk
#
# \brief
# Defines, needed for the PSoC 6 build recipe.
#
################################################################################
# \copyright
# Copyright 2018-2020 Cypress Semiconductor Corporation
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

ifeq ($(WHICHFILE),true)
$(info Processing $(lastword $(MAKEFILE_LIST)))
endif

include $(CY_INTERNAL_BASELIB_PATH)/make/recipe/defines_common.mk


################################################################################
# General
################################################################################

#
# Define the default core
#
CORE?=CM4
CY_START_FLASH=0x10000000
CY_START_SRAM=0x08000000

#
# Core specifics
#
CY_JLINKSCRIPT_CORE=CM4
CY_JLINK_DEVICE_CFG_DEBUG_SUFFIX=
CY_OPENOCD_CORE=cm4
CY_GDBINIT_FILE=gdbinit
CY_OPENOCD_SECOND_RESET_TYPE=run
CY_ECLIPSE_TEMPLATES_WILDCARD=$(CORE)/*
ifeq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_M0P)))
ifeq ($(CORE),CM0P)
$(call CY_MACRO_ERROR,$(DEVICE) does not have a CM0+ core)
endif
CY_LINKERSCRIPT_SUFFIX?=cm4
CY_OPENOCD_EXTRA_PORT_FLAG=
CY_OPENOCD_EXTRA_PORT_ECLIPSE=
CY_OPENOCD_CM0_DISABLE_FLAG=set ENABLE_CM0 0
CY_OPENOCD_CM0_DISABLE_ECLIPSE=-c \&quot;$(CY_OPENOCD_CM0_DISABLE_FLAG)\&quot;\&\#13;\&\#10;
else
ifeq ($(CORE),CM0P)
CY_LINKERSCRIPT_SUFFIX?=cm0plus
CY_JLINKSCRIPT_CORE=CM0p
CY_JLINK_DEVICE_CFG_DEBUG_SUFFIX=_tm
CY_OPENOCD_CORE=cm0
CY_OPENOCD_SECOND_RESET_TYPE=init
CY_GDBINIT_FILE=gdbinit_cm0
else
CY_LINKERSCRIPT_SUFFIX?=cm4_dual
CY_OPENOCD_EXTRA_PORT_FLAG=gdb_port 3332
CY_OPENOCD_EXTRA_PORT_ECLIPSE=-c \&quot;$(CY_OPENOCD_EXTRA_PORT_FLAG)\&quot;\&\#13;\&\#10;
CY_OPENOCD_CM0_DISABLE_FLAG=
CY_OPENOCD_CM0_DISABLE_ECLIPSE=
endif
endif

#
# Secure targets specifics
#
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_SECURE)))
CY_GDBINIT_FILE=gdbinit_secure
CY_OPENOCD_CM0_DISABLE_FLAG=set TARGET_AP cm4_ap
CY_OPENOCD_CM0_DISABLE_ECLIPSE=-c \&quot;$(CY_OPENOCD_CM0_DISABLE_FLAG)\&quot;\&\#13;\&\#10;
CY_OPENOCD_SECOND_RESET_TYPE=init
CY_OPENOCD_EXTRA_PORT_FLAG=
CY_OPENOCD_EXTRA_PORT_ECLIPSE=
CY_OPENOCD_RUN_RESTART_CMD_DEBUG_ECLIPSE=flushregs
CY_OPENOCD_RUN_RESTART_CMD_ATTACH_ECLIPSE=$(CY_OPENOCD_RUN_RESTART_CMD_DEBUG_ECLIPSE)
CY_OPENOCD_SMIF_DISABLE=set DISABLE_SMIF 1
CY_OPENOCD_SMIF_DISABLE_ECLIPSE=-c \&quot;$(CY_OPENOCD_SMIF_DISABLE)\&quot;\&\#13;\&\#10;
CY_ECLIPSE_TEMPLATES_WILDCARD=$(CORE)/*KitProg3*
CY_OPENOCD_SHELL_TIMEOUT_CMD=shell sleep 5
CY_OPENOCD_SHELL_TIMEOUT_ECLIPSE=$(CY_OPENOCD_SHELL_TIMEOUT_CMD)\&\#13;\&\#10;
else
CY_OPENOCD_RUN_RESTART_CMD_DEBUG_ECLIPSE=mon psoc6 reset_halt sysresetreq\&\#13;\&\#10;flushregs\&\#13;\&\#10;mon gdb_sync\&\#13;\&\#10;stepi
CY_OPENOCD_RUN_RESTART_CMD_ATTACH_ECLIPSE=flushregs\&\#13;\&\#10;mon gdb_sync\&\#13;\&\#10;stepi
endif

#
# Architecure specifics
#
CY_OPENOCD_CHIP_NAME=psoc6
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6ABLE2)))

CY_PSOC_ARCH=psoc6_01
CY_PSOC_DIE_NAME=PSoC6ABLE2
CY_OPENOCD_DEVICE_CFG=psoc6.cfg
CY_JLINK_DEVICE_CFG_PROGRAM=CY8C6xx7_CM0p_sect256KB_tm
CY_JLINK_DEVICE_CFG_ATTACH=CY8C6xx7_$(CY_JLINKSCRIPT_CORE)_sect256KB
CY_JLINK_DEVICE_CFG_DEBUG=$(CY_JLINK_DEVICE_CFG_ATTACH)$(CY_JLINK_DEVICE_CFG_DEBUG_SUFFIX)
ifeq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_M0P)))
CY_JLINK_DEVICE_CFG_PROGRAM=CY8C6xx6_CM4_sect256KB
CY_JLINK_DEVICE_CFG_ATTACH=CY8C6xx6_$(CY_JLINKSCRIPT_CORE)_sect256KB
CY_JLINK_DEVICE_CFG_DEBUG=$(CY_JLINK_DEVICE_CFG_ATTACH)$(CY_JLINK_DEVICE_CFG_DEBUG_SUFFIX)
endif
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_SECURE)))
CY_PSOC_ARCH=psoc6_secure
CY_PSOC_DIE_NAME=PSoC6ABLE2Secure
CY_OPENOCD_CHIP_NAME=psoc64
CY_OPENOCD_DEVICE_CFG=psoc6_secure.cfg
endif

else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6A2M)))

CY_PSOC_ARCH=psoc6_02
CY_PSOC_DIE_NAME=PSoC6A2M
CY_OPENOCD_DEVICE_CFG=psoc6_2m.cfg
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_2048)))
CY_JLINK_DEVICE_CFG_ATTACH=CY8C6xxA_$(CY_JLINKSCRIPT_CORE)_sect256KB
ifeq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_M0P)))
CY_JLINK_DEVICE_CFG_PROGRAM=CY8C6xxA_CM4_sect256KB
else
CY_JLINK_DEVICE_CFG_PROGRAM=CY8C6xxA_CM0p_sect256KB_tm
endif
else
CY_JLINK_DEVICE_CFG_ATTACH=CY8C6xx8_$(CY_JLINKSCRIPT_CORE)_sect256KB
ifeq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_M0P)))
CY_JLINK_DEVICE_CFG_PROGRAM=CY8C6xx8_CM4_sect256KB
else
CY_JLINK_DEVICE_CFG_PROGRAM=CY8C6xx8_CM0p_sect256KB_tm
endif
endif
CY_JLINK_DEVICE_CFG_DEBUG=$(CY_JLINK_DEVICE_CFG_ATTACH)$(CY_JLINK_DEVICE_CFG_DEBUG_SUFFIX)
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_SECURE)))
CY_PSOC_ARCH=psoc6_2m_secure
CY_PSOC_DIE_NAME=PSoC6A2MSecure
CY_OPENOCD_CHIP_NAME=psoc64
CY_OPENOCD_DEVICE_CFG=psoc6_2m_secure.cfg
endif

else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6A512K)))

CY_PSOC_ARCH=psoc6_03
CY_PSOC_DIE_NAME=PSoC6A512K
CY_OPENOCD_DEVICE_CFG=psoc6_512k.cfg
CY_JLINK_DEVICE_CFG_PROGRAM=CY8C6xx5_CM0p_sect256KB_tm
CY_JLINK_DEVICE_CFG_ATTACH=CY8C6xx5_$(CY_JLINKSCRIPT_CORE)_sect256KB
CY_JLINK_DEVICE_CFG_DEBUG=$(CY_JLINK_DEVICE_CFG_ATTACH)$(CY_JLINK_DEVICE_CFG_DEBUG_SUFFIX)
ifeq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_M0P)))
CY_JLINK_DEVICE_CFG_PROGRAM=CY8C6xx5_CM4_sect256KB
endif
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_SECURE)))
CY_PSOC_ARCH=psoc6_512k_secure
CY_PSOC_DIE_NAME=PSoC6A512KSecure
CY_OPENOCD_CHIP_NAME=psoc64
CY_OPENOCD_DEVICE_CFG=psoc6_512k_secure.cfg
endif

else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6A256K)))

CY_PSOC_ARCH=psoc6_04
CY_PSOC_DIE_NAME=PSoC6A256K
CY_OPENOCD_DEVICE_CFG=psoc6_256k.cfg
CY_JLINK_DEVICE_CFG_PROGRAM=CY8C6xx4_CM0p_sect128KB_tm
CY_JLINK_DEVICE_CFG_ATTACH=CY8C6xx4_$(CY_JLINKSCRIPT_CORE)_sect128KB
CY_JLINK_DEVICE_CFG_DEBUG=$(CY_JLINK_DEVICE_CFG_ATTACH)$(CY_JLINK_DEVICE_CFG_DEBUG_SUFFIX)

else
$(call CY_MACRO_ERROR,Incorrect part number $(DEVICE). Check DEVICE variable.)
endif

#
# Flash memory specifics
#
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_256)))
CY_MEMORY_FLASH=262144
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_448)))
CY_MEMORY_FLASH=458752
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_512)))
CY_MEMORY_FLASH=524288
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_832)))
CY_MEMORY_FLASH=850944
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_1024)))
CY_MEMORY_FLASH=1048576
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_1856)))
CY_MEMORY_FLASH=1899520
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_2048)))
CY_MEMORY_FLASH=2097152
else
$(call CY_MACRO_ERROR,No Flash memory size defined for $(DEVICE))
endif

#
# SRAM memory specifics
#
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_SRAM_KB_128)))
CY_MEMORY_SRAM=129024
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_SRAM_KB_256)))
CY_MEMORY_SRAM=260096
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_SRAM_KB_288)))
CY_MEMORY_SRAM=292864
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_SRAM_KB_512)))
CY_MEMORY_SRAM=522240
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_SRAM_KB_1024)))
CY_MEMORY_SRAM=1046528
else
$(call CY_MACRO_ERROR,No SRAM memory size defined for $(DEVICE))
endif

#
# linker scripts
#

# Secure parts
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_SECURE)))

ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6ABLE2)))
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_832)))
CY_LINKER_SCRIPT_NAME=cyb06xx7
endif
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6A2M)))
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_1856)))
CY_LINKER_SCRIPT_NAME=cyb06xxa
endif
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6A512K)))
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_448)))
CY_LINKER_SCRIPT_NAME=cyb06xx5
endif
endif

# Non-secure part
else

ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6A256K)))
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_256)))
CY_LINKER_SCRIPT_NAME=cy8c6xx4
endif
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6A512K)))
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_512)))
CY_LINKER_SCRIPT_NAME=cy8c6xx5
endif
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6ABLE2)))
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_512)))
CY_LINKER_SCRIPT_NAME=cy8c6xx6
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_1024)))
CY_LINKER_SCRIPT_NAME=cy8c6xx7
endif
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_DIE_PSOC6A2M)))
ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_1024)))
CY_LINKER_SCRIPT_NAME=cy8c6xx8
else ifneq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_FLASH_KB_2048)))
CY_LINKER_SCRIPT_NAME=cy8c6xxa
endif
endif

endif

ifeq ($(CY_LINKER_SCRIPT_NAME),)
$(call CY_MACRO_ERROR,Could not resolve device series for linker script)
endif


################################################################################
# BSP generation
################################################################################

DEVICE_GEN?=$(DEVICE)
ADDITIONAL_DEVICES_GEN?=$(ADDITIONAL_DEVICES)

# Core specifics
ifeq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_M0P)))
CY_BSP_LINKERSCRIPT_CM4_SUFFIX=cm4
CY_BSP_STARTUP_CM4_SUFFIX=cm4
else
CY_BSP_LINKERSCRIPT_CM0P_SUFFIX=cm0plus
CY_BSP_STARTUP_CM0P_SUFFIX=cm0plus
CY_BSP_LINKERSCRIPT_CM4_SUFFIX=cm4_dual
CY_BSP_STARTUP_CM4_SUFFIX=cm4
endif

# Architecture specifics
ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_DIE_PSOC6ABLE2)))
CY_BSP_STARTUP=psoc6_01
else ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_DIE_PSOC6A2M)))
CY_BSP_STARTUP=psoc6_02
else ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_DIE_PSOC6A512K)))
CY_BSP_STARTUP=psoc6_03
else ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_DIE_PSOC6A256K)))
CY_BSP_STARTUP=psoc6_04
endif

# Linker scripts - Secure parts
ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_SECURE)))

ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_DIE_PSOC6ABLE2)))
ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_FLASH_KB_832)))
CY_BSP_LINKER_SCRIPT=cyb06xx7
endif
else ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_DIE_PSOC6A2M)))
ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_FLASH_KB_1856)))
CY_BSP_LINKER_SCRIPT=cyb06xxa
endif
endif

# Linker scripts - Non-secure parts
else

ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_DIE_PSOC6A256K)))
ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_FLASH_KB_256)))
CY_BSP_LINKER_SCRIPT=cy8c6xx4
endif
else ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_DIE_PSOC6A512K)))
ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_FLASH_KB_512)))
CY_BSP_LINKER_SCRIPT=cy8c6xx5
endif
else ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_DIE_PSOC6ABLE2)))
ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_FLASH_KB_512)))
CY_BSP_LINKER_SCRIPT=cy8c6xx6
else ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_FLASH_KB_1024)))
CY_BSP_LINKER_SCRIPT=cy8c6xx7
endif
else ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_DIE_PSOC6A2M)))
ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_FLASH_KB_1024)))
CY_BSP_LINKER_SCRIPT=cy8c6xx8
else ifneq (,$(findstring $(DEVICE_GEN),$(CY_DEVICES_WITH_FLASH_KB_2048)))
CY_BSP_LINKER_SCRIPT=cy8c6xxa
endif
endif

endif

CY_BSP_LINKER_SCRIPT_CM0P=$(CY_BSP_LINKER_SCRIPT)_$(CY_BSP_LINKERSCRIPT_CM0P_SUFFIX)
CY_BSP_LINKER_SCRIPT_CM4=$(CY_BSP_LINKER_SCRIPT)_$(CY_BSP_LINKERSCRIPT_CM4_SUFFIX)
CY_BSP_STARTUP_CM0P=$(CY_BSP_STARTUP)_$(CY_BSP_STARTUP_CM0P_SUFFIX)
CY_BSP_STARTUP_CM4=$(CY_BSP_STARTUP)_$(CY_BSP_STARTUP_CM4_SUFFIX)

# Paths
CY_BSP_TEMPLATES_DIR=$(call CY_MACRO_DIR,$(firstword $(CY_DEVICESUPPORT_SEARCH_PATH)))/devices/COMPONENT_CAT1A/templates/COMPONENT_MTB
ifeq ($(wildcard $(CY_BSP_TEMPLATES_DIR)),)
CY_BSP_TEMPLATES_DIR=$(call CY_MACRO_DIR,$(firstword $(CY_DEVICESUPPORT_SEARCH_PATH)))/devices/templates/COMPONENT_MTB
endif
CY_BSP_DESTINATION_DIR=$(CY_TARGET_GEN_DIR)/COMPONENT_CM0P $(CY_TARGET_GEN_DIR)/COMPONENT_CM4
CY_BSP_DESTINATION_ABSOLUTE=$(abspath $(CY_TARGET_GEN_DIR))

ifeq ($(strip $(CY_BSP_LINKER_SCRIPT) $(CY_BSP_STARTUP)),)
CY_BSP_TEMPLATES_CMD=echo "Could not locate template linker scripts and startup files for DEVICE $(DEVICE_GEN). Skipping update...";
endif

# Command for searching files in the template directory
CY_BSP_SEARCH_FILES_CMD=\
	-name "system_psoc6*" \
	-o -name "*$(CY_BSP_STARTUP_CM0P)*" \
	-o -name "*$(CY_BSP_STARTUP_CM4)*" \
	-o -name "*$(CY_BSP_LINKER_SCRIPT_CM0P)*" \
	-o -name "*$(CY_BSP_LINKER_SCRIPT_CM4)*"


################################################################################
# IDE specifics
################################################################################

ifeq ($(filter vscode,$(MAKECMDGOALS)),vscode)
CY_VSCODE_JSON_PROCESSING=\
	if [[ $$jsonFile == "launch.json" ]]; then\
		if [[ $(CY_OPENOCD_CHIP_NAME) == "psoc64" ]]; then\
			grep -v "//PSoC6 Only//" $(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile >\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile;\
			sed -e '/\/\/JLink Start PSoC6 Only\/\//,/\/\/JLink End PSoC6 Only\/\//d'\
				-e 's/\/\/PSoC64 Only\/\///g' $(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile >\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile;\
		else\
			grep -v "//PSoC64 Only//" $(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile >\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile;\
			sed -e 's/\/\/JLink Start PSoC6 Only\/\///g' -e 's/\/\/JLink End PSoC6 Only\/\///g'\
				-e 's/\/\/PSoC6 Only\/\///g' $(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile >\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile;\
		fi;\
		rm $(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile;\
	fi;

CY_VSCODE_OPENOCD_PROCESSING=\
	if [[ $(CY_OPENOCD_CHIP_NAME) == "psoc6" ]]; then\
		grep -v "set TARGET_AP cm4_ap" $(CY_VSCODE_OUT_PATH)/openocd.tcl > $(CY_VSCODE_OUT_PATH)/_openocd.tcl;\
		mv -f $(CY_VSCODE_OUT_PATH)/_openocd.tcl $(CY_VSCODE_OUT_PATH)/openocd.tcl;\
	fi;\
	if echo "$(CY_DEVICES_WITH_M0P)" | grep -q "$(DEVICE)"; then\
		grep -v "set ENABLE_CM0 0" $(CY_VSCODE_OUT_PATH)/openocd.tcl > $(CY_VSCODE_OUT_PATH)/_openocd.tcl;\
		mv -f $(CY_VSCODE_OUT_PATH)/_openocd.tcl $(CY_VSCODE_OUT_PATH)/openocd.tcl;\
	fi;\

CY_VSCODE_ARGS+="s|&&CY_DEVICE_PROGRAM&&|$(CY_JLINK_DEVICE_CFG_PROGRAM)|g;"\
				"s|&&CY_DEVICE_DEBUG&&|$(CY_JLINK_DEVICE_CFG_DEBUG)|g;"\
				"s|&&CY_OPENOCD_CHIP&&|$(CY_OPENOCD_CHIP_NAME)|g;"

ifeq ($(CORE),CM0P)
CY_VSCODE_ARGS+="s|&&CY_TARGET_PROCESSOR_NAME&&|CM0+|g;"\
				"s|&&CY_TARGET_PROCESSOR_NUMBER&&|0|g;"\
				"s|&&CY_PROCESSOR_COUNT&&|2|g;"
else
ifeq (,$(findstring $(DEVICE),$(CY_DEVICES_WITH_M0P)))
CY_VSCODE_ARGS+="s|&&CY_TARGET_PROCESSOR_NAME&&|CM4|g;"\
				"s|&&CY_TARGET_PROCESSOR_NUMBER&&|0|g;"\
				"s|&&CY_PROCESSOR_COUNT&&|1|g;"
else
CY_VSCODE_ARGS+="s|&&CY_TARGET_PROCESSOR_NAME&&|CM4|g;"\
				"s|&&CY_TARGET_PROCESSOR_NUMBER&&|1|g;"\
				"s|&&CY_PROCESSOR_COUNT&&|2|g;"
endif
endif
endif

ifeq ($(CORE),CM4)
ifneq (,$(findstring $(DEVICE), $(CY_DEVICES_WITH_M0P)))
CY_IAR_CORE_SUFFIX="M4"
endif
endif
ifeq ($(CORE),CM0P)
CY_IAR_CORE_SUFFIX="M0+"
endif

# The device name format needs to match the name of the device in the IAR database.
# Expected format for Cypress single core devices is {MPN-name}.
# Expected format for Cypress multi core device is {MPN-name}{Core}.
CY_IAR_DEVICE_NAME=$(DEVICE)$(CY_IAR_CORE_SUFFIX)

ifeq ($(filter eclipse,$(MAKECMDGOALS)),eclipse)
CY_ECLIPSE_ARGS+="s|&&CY_OPENOCD_SECOND_RESET&&|$(CY_OPENOCD_SECOND_RESET_TYPE)|g;"\
				"s|&&CY_OPENOCD_RUN_RESTART_DEBUG_CMD&&|$(CY_OPENOCD_RUN_RESTART_CMD_DEBUG_ECLIPSE)|g;"\
				"s|&&CY_OPENOCD_RUN_RESTART_ATTACH_CMD&&|$(CY_OPENOCD_RUN_RESTART_CMD_ATTACH_ECLIPSE)|g;"\
				"s|&&CY_OPENOCD_SHELL_TIMEOUT&&|$(CY_OPENOCD_SHELL_TIMEOUT_ECLIPSE)|g;"\
				"s|&&CY_JLINK_CFG_PROGRAM&&|$(CY_JLINK_DEVICE_CFG_PROGRAM)|g;"\
				"s|&&CY_JLINK_CFG_DEBUG&&|$(CY_JLINK_DEVICE_CFG_DEBUG)|g;"\
				"s|&&CY_JLINK_CFG_ATTACH&&|$(CY_JLINK_DEVICE_CFG_ATTACH)|g;"\
				"s|&&CY_OPENOCD_PORT_SELECT&&|$(CY_OPENOCD_EXTRA_PORT_ECLIPSE)|g;"\
				"s|&&CY_OPENOCD_CM0_FLAG&&|$(CY_OPENOCD_CM0_DISABLE_ECLIPSE)|g;"\
				"s|&&CY_OPENOCD_SMIF_DISABLE&&|$(CY_OPENOCD_SMIF_DISABLE_ECLIPSE)|g;"\
				"s|&&CY_CORE&&|$(CY_OPENOCD_CORE)|g;"\
				"s|&&CY_QSPI_CFG_PATH&&|$(CY_OPENOCD_QSPI_CFG_PATH_WITH_FLAG)|g;"
endif

################################################################################
# Tools specifics
################################################################################

CY_SUPPORTED_TOOL_TYPES+=\
	qspi-configurator

# PSoC 6 smartio also uses the .modus extension
modus_DEFAULT_TYPE+=device-configurator smartio-configurator

# PSoC 6 capsense-tuner shares its existence with capsense-configurator
CY_OPEN_NEWCFG_XML_TYPES+=capsense-tuner
