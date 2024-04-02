################################################################################
# \file recipe_ide.mk
#
# \brief
# This make file defines the IDE export variables and target.
#
################################################################################
# \copyright
# Copyright 2022-2024 Cypress Semiconductor Corporation
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

##############################################
# General
##############################################
MTB_RECIPE__IDE_SUPPORTED:=eclipse vscode uvision5 ewarm8

include $(MTB_TOOLS__RECIPE_DIR)/make/recipe/interface_version_2/recipe_ide_common.mk

##############################################
# Eclipe VSCode
##############################################

ifeq ($(firstword $(MTB_APPLICATION_SUBPROJECTS)),$(notdir $(realpath $(MTB_TOOLS__PRJ_DIR))))
_MTB_RECIPE__IS_FIRST_PRJ=1
endif

_MTB_RECIPE__IDE_TEXT_DATA_FILE=$(MTB_TOOLS__OUTPUT_CONFIG_DIR)/recipe_ide_text_data.txt

##############################################
# Eclipe
##############################################
_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE:=$(MTB_TOOLS__OUTPUT_CONFIG_DIR)/recipe_eclipse_template_meta_data.txt
eclipse_generate: recipe_eclipse_text_replacement_data_file recipe_eclipse_meta_data_file
eclipse_generate: MTB_CORE__EXPORT_CMDLINE += -textdata $(_MTB_RECIPE__IDE_TEXT_DATA_FILE) -metadata $(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE)

recipe_eclipse_text_replacement_data_file:
	$(call mtb__file_write,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_SECOND_RESET&&=$(_MTB_RECIPE__OPENOCD_SECOND_RESET_TYPE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_RUN_RESTART_DEBUG_CMD&&=$(_MTB_RECIPE__OPENOCD_RUN_RESTART_CMD_DEBUG_ECLIPSE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_RUN_RESTART_ATTACH_CMD&&=$(_MTB_RECIPE__OPENOCD_RUN_RESTART_CMD_ATTACH_ECLIPSE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_SHELL_TIMEOUT&&=$(CY_OPENOCD_SHELL_TIMEOUT_ECLIPSE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__JLINK_CFG_PROGRAM&&=$(_MTB_RECIPE__JLINK_DEVICE_CFG_PROGRAM))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__JLINK_CFG_DEBUG&&=$(_MTB_RECIPE__JLINK_DEVICE_CFG_DEBUG))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__JLINK_CFG_ATTACH&&=$(_MTB_RECIPE__JLINK_DEVICE_CFG_ATTACH))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_PORT_SELECT&&=$(_MTB_RECIPE__OPENOCD_EXTRA_PORT_ECLIPSE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_CM0_FLAG&&=$(_MTB_RECIPE__OPENOCD_CM0_DISABLE_ECLIPSE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_TARGET_AP&&=$(_MTB_RECIPE__OPENOCD_TARGET_AP_ECLIPSE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_TARGET_AP_DEBUG&&=$(_MTB_RECIPE__OPENOCD_TARGET_AP_DEBUG_ECLIPSE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_SMIF_DISABLE&&=$(_MTB_RECIPE__OPENOCD_SMIF_DISABLE_ECLIPSE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_MONITOR_CMDS_NAME&&=$(_MTB_RECIPE__OPENOCD_MONITOR_CMDS_NAME))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__CORE&&=$(_MTB_RECIPE__OPENOCD_CORE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__QSPI_CFG_PATH&&=$(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH_WITH_FLAG))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__QSPI_CFG_PATH_APPLICATION&&=$(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH_APPLICATION_WITH_FLAG))
ifneq (,$(_MTB_RECIPE__IS_SECURE_DEVICE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__PRJ_1_NAME&&=$(lastword $(MTB_APPLICATION_SUBPROJECTS)))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__PRJ_2_NAME&&=$(firstword $(MTB_APPLICATION_SUBPROJECTS)))
else
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__PRJ_1_NAME&&=$(firstword $(MTB_APPLICATION_SUBPROJECTS)))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__PRJ_2_NAME&&=$(lastword $(MTB_APPLICATION_SUBPROJECTS)))
endif
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_CM0_RTOS_CONFIG&&=$(_MTB_RECIPE__OPENOCD_CM0_RTOS_CONFIG))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_CM4_RTOS_CONFIG&&=$(_MTB_RECIPE__OPENOCD_CM4_RTOS_CONFIG))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__MULTICORE_SECOND_CONFIG_ECLIPSE&&=$(_MTB_RECIPE__MULTICORE_SECOND_CONFIG_ECLIPSE))

recipe_eclipse_meta_data_file:
	$(call mtb__file_write,$(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE),UUID=&&PROJECT_UUID_$(MTB_RECIPE__CORE)&&)
	$(call mtb__file_append,$(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE),UUID=&&PROJECT_UUID&&)
ifneq (,$(_MTB_RECIPE__IS_MULTI_CORE_APPLICATION))
	$(call mtb__file_append,$(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE),APPLICATION_UUID=&&APPLICATION_UUID&&)
ifneq (,$(_MTB_RECIPE__IS_FIRST_PRJ))
	$(call mtb__file_append,$(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_RECIPE__IDE_TEMPLATE_DIR)/eclipse/Application/$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)=../.mtbLaunchConfigs)
	$(call mtb__file_append,$(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE),UPDATE_APPLICATION_PREF_FILE=1)
else
	$(call mtb__file_append,$(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=../.mtbLaunchConfigs=../.mtbLaunchConfigs)
endif #(,$(_MTB_RECIPE__IS_FIRST_PRJ))
ifeq (,$(_MTB_RECIPE__IS_SECURE_DEVICE))
ifneq (,$(wildcard $(_MTB_RECIPE__IDE_TEMPLATE_DIR)/eclipse/$(MTB_RECIPE__CORE)/$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)/multi_core))
	$(call mtb__file_append,$(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_RECIPE__IDE_TEMPLATE_DIR)/eclipse/$(MTB_RECIPE__CORE)/$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)/multi_core=.mtbLaunchConfigs)
endif
else
ifneq (,$(wildcard $(_MTB_RECIPE__IDE_TEMPLATE_DIR)/eclipse/$(MTB_RECIPE__CORE)/$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)/multi_core_secure))
	$(call mtb__file_append,$(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_RECIPE__IDE_TEMPLATE_DIR)/eclipse/$(MTB_RECIPE__CORE)/$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)/multi_core_secure=.mtbLaunchConfigs)
endif
endif
else #(,$(_MTB_RECIPE__IS_MULTI_CORE_APPLICATION))
	$(call mtb__file_append,$(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_RECIPE__IDE_TEMPLATE_DIR)/eclipse/$(MTB_RECIPE__CORE)/$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)/single_core=.mtbLaunchConfigs)
endif #(,$(_MTB_RECIPE__IS_MULTI_CORE_APPLICATION))
	$(call mtb__file_append,$(_MTB_RECIPE__ECLIPSE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_RECIPE__IDE_TEMPLATE_DIR)/eclipse/$(MTB_RECIPE__CORE)/$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)/any_core=.mtbLaunchConfigs)

.PHONY: recipe_eclipse_text_replacement_data_file recipe_eclipse_meta_data_file

##############################################
# VSCode
##############################################
_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE:=$(MTB_TOOLS__OUTPUT_CONFIG_DIR)/recipe_vscode_template_meta_data.txt
_MTB_RECIPE__VSCODE_TEMPLATE_REGEX_DATA_FILE:=$(MTB_TOOLS__OUTPUT_CONFIG_DIR)/recipe_vscode_template_regex_data.txt
vscode_generate: recipe_vscode_text_replacement_data_file recipe_vscode_meta_data_file recipe_vscode_regex_replacement_data_file
vscode_generate: MTB_CORE__EXPORT_CMDLINE += -textdata $(_MTB_RECIPE__IDE_TEXT_DATA_FILE) -metadata $(_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE) -textregexdata $(_MTB_RECIPE__VSCODE_TEMPLATE_REGEX_DATA_FILE)

recipe_vscode_text_replacement_data_file:
	$(call mtb__file_write,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__DEVICE_PROGRAM&&=$(_MTB_RECIPE__JLINK_DEVICE_CFG_PROGRAM))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__DEVICE_DEBUG&&=$(_MTB_RECIPE__JLINK_DEVICE_CFG_DEBUG))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_CHIP&&=$(_MTB_RECIPE__OPENOCD_CHIP_NAME))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_CORE&&=$(_MTB_RECIPE__OPENOCD_CORE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__QSPI_CFG_PATH&&=$(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__QSPI_CFG_PATH_APPLICATION&&=$(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH_APPLICATION))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__MULTICORE_SECOND_CONFIG_VSCODE&&=$(_MTB_RECIPE__MULTICORE_SECOND_CONFIG_VSCODE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_MONITOR_CMDS_NAME&&=$(_MTB_RECIPE__OPENOCD_MONITOR_CMDS_NAME))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__MCU_NAME&&=$(_MTB_RECIPE__MCU_NAME))
ifneq (,$(_MTB_RECIPE__IS_SECURE_DEVICE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__FIRST_APP_NAME&&=$(lastword $(MTB_APPLICATION_SUBPROJECTS)))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__SECOND_APP_NAME&&=$(firstword $(MTB_APPLICATION_SUBPROJECTS)))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__TARGET_PROCESSOR_NUMBER_MULTICORE&&=1)
else
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__FIRST_APP_NAME&&=$(firstword $(MTB_APPLICATION_SUBPROJECTS)))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__SECOND_APP_NAME&&=$(lastword $(MTB_APPLICATION_SUBPROJECTS)))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__TARGET_PROCESSOR_NUMBER_MULTICORE&&=0)
endif
ifeq ($(MTB_RECIPE__CORE),CM0P)
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__TARGET_PROCESSOR_NAME&&=CM0+)
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__TARGET_PROCESSOR_NUMBER&&=0)
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__PROCESSOR_COUNT&&=2)
else
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__TARGET_PROCESSOR_NAME&&=CM4)
ifeq (,$(_MTB_RECIPE__IS_MULTI_CORE_DEVICE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__TARGET_PROCESSOR_NUMBER&&=0)
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__PROCESSOR_COUNT&&=1)
else
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__TARGET_PROCESSOR_NUMBER&&=1)
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__PROCESSOR_COUNT&&=2)
endif #ifeq (,$(_MTB_RECIPE__IS_MULTI_CORE_DEVICE))
endif #ifeq ($(MTB_RECIPE__CORE),CM0P)
ifeq (psoc64,$(_MTB_RECIPE__OPENOCD_CHIP_NAME))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_PSOC6_TARGET_AP&&=set TARGET_AP $(_MTB_RECIPE__OPENOCD_CORE)_ap)
ifeq (,$(_MTB_RECIPE__IS_FIRST_PRJ))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__CM0_CM4_ELF_FILE_APPLICATION&&=$(_MTB_RECIPE__VSCODE_ELF_FILE_APPLICATION))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__CM0_CM4_JLINK_DEVICE&&=$(_MTB_RECIPE__JLINK_DEVICE_CFG_DEBUG))
endif
else
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_PSOC6_TARGET_AP&&=)
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__CM0_CM4_ELF_FILE_APPLICATION&&=$(_MTB_RECIPE__VSCODE_ELF_FILE_APPLICATION))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__CM0_CM4_JLINK_DEVICE&&=$(_MTB_RECIPE__JLINK_DEVICE_CFG_DEBUG))
endif
ifneq (true,$(_MTB_RECIPE__IS_MULTI_CORE_DEVICE))
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_ENABLE_CM0&&=set ENABLE_CM0 0)
else
	$(call mtb__file_append,$(_MTB_RECIPE__IDE_TEXT_DATA_FILE),&&_MTB_RECIPE__OPENOCD_ENABLE_CM0&&=)
endif

recipe_vscode_regex_replacement_data_file:
ifeq (psoc64,$(_MTB_RECIPE__OPENOCD_CHIP_NAME))
	$(call mtb__file_write,$(_MTB_RECIPE__VSCODE_TEMPLATE_REGEX_DATA_FILE),^(.*)//PSoC64 Only//(.*)$$=\1\2)
	$(call mtb__file_append,$(_MTB_RECIPE__VSCODE_TEMPLATE_REGEX_DATA_FILE),^.*//PSoC6 Only//.*$$=)
else
	$(call mtb__file_write,$(_MTB_RECIPE__VSCODE_TEMPLATE_REGEX_DATA_FILE),^(.*)//PSoC6 Only//(.*)$$=\1\2)
	$(call mtb__file_append,$(_MTB_RECIPE__VSCODE_TEMPLATE_REGEX_DATA_FILE),^.*//PSoC64 Only//.*$$=)
endif

recipe_vscode_meta_data_file:
	$(call mtb__file_write,$(_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_RECIPE__IDE_TEMPLATE_DIR)/vscode/CMx/openocd.tcl=openocd.tcl)
ifneq (,$(_MTB_RECIPE__IS_MULTI_CORE_APPLICATION))
	$(call mtb__file_append,$(_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_RECIPE__IDE_TEMPLATE_DIR)/vscode/CMx/$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)/launch_multicore.json=.vscode/launch.json)
	$(call mtb__file_append,$(_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_CORE__IDE_TEMPLATE_DIR)/vscode/dependencies_tasks.json=.vscode/tasks.json)
ifneq (,$(_MTB_RECIPE__IS_FIRST_PRJ))
	$(call mtb__file_append,$(_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_RECIPE__IDE_TEMPLATE_DIR)/vscode/Application/openocd.tcl=../openocd.tcl)
	$(call mtb__file_append,$(_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_RECIPE__IDE_TEMPLATE_DIR)/vscode/Application/$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)/launch.json=../.vscode/launch.json)
	$(call mtb__file_append,$(_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(MTB_TOOLS__CORE_DIR)/make/scripts/interface_version_2/vscode/tasks.json=../.vscode/tasks.json)
else
	$(call mtb__file_append,$(_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=../.vscode=../.vscode)
endif
else #(,$(_MTB_RECIPE__IS_MULTI_CORE_APPLICATION))
	$(call mtb__file_append,$(_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(_MTB_RECIPE__IDE_TEMPLATE_DIR)/vscode/CMx/$(_MTB_RECIPE__PROGRAM_INTERFACE_SUBDIR)/launch.json=.vscode/launch.json)
	$(call mtb__file_append,$(_MTB_RECIPE__VSCODE_TEMPLATE_META_DATA_FILE),TEMPLATE_REPLACE=$(MTB_TOOLS__CORE_DIR)/make/scripts/interface_version_2/vscode/tasks.json=.vscode/tasks.json)
endif #(,$(_MTB_RECIPE__IS_MULTI_CORE_APPLICATION))

.PHONY: recipe_vscode_text_replacement_data_file recipe_vscode_meta_data_file recipe_vscode_regex_replacement_data_file

##############################################
# EW UV
##############################################
_MTB_RECIPE__IDE_BUILD_DATA_FILE:=$(MTB_TOOLS__OUTPUT_CONFIG_DIR)/recipe_ide_build_data.txt

ewarm8 uvision5: recipe_build_data_file
ewarm8 uvision5: MTB_CORE__EXPORT_CMDLINE += -build_data $(_MTB_RECIPE__IDE_BUILD_DATA_FILE)

recipe_build_data_file:
	$(call mtb__file_write,$(_MTB_RECIPE__IDE_BUILD_DATA_FILE),LINKER_SCRIPT=$(MTB_RECIPE__LINKER_SCRIPT))

.PHONY:recipe_build_data_file

##############################################
# UV
##############################################
_MTB_RECIPE__CMSIS_ARCH_NAME:=CAT1A_DFP
_MTB_RECIPE__CMSIS_VENDOR_NAME:=Infineon
_MTB_RECIPE__CMSIS_VENDOR_ID:=7

# Define _MTB_RECIPE__CMSIS_PNAME for export into uVision
ifeq ($(MTB_RECIPE__CORE),CM0P)
_MTB_RECIPE__CMSIS_PNAME:=Cortex-M0p
else ifeq ($(MTB_RECIPE__CORE),CM4)
_MTB_RECIPE__CMSIS_PNAME:=Cortex-M4
else
_MTB_RECIPE__CMSIS_PNAME:=
endif

_MTB_RECIPE__UV_DFP_DATA_FILE:=$(MTB_TOOLS__OUTPUT_CONFIG_DIR)/recipe_ide_dfp_data.txt

uvision5: recipe_uvision5_dfp_data_file
uvision5: MTB_CORE__EXPORT_CMDLINE += -dfp_data $(_MTB_RECIPE__UV_DFP_DATA_FILE)

recipe_uvision5_dfp_data_file:
	$(call mtb__file_write,$(_MTB_RECIPE__UV_DFP_DATA_FILE),DEVICE=$(DEVICE))
	$(call mtb__file_append,$(_MTB_RECIPE__UV_DFP_DATA_FILE),DFP_NAME=$(_MTB_RECIPE__CMSIS_ARCH_NAME))
	$(call mtb__file_append,$(_MTB_RECIPE__UV_DFP_DATA_FILE),VENDOR_NAME=$(_MTB_RECIPE__CMSIS_VENDOR_NAME))
	$(call mtb__file_append,$(_MTB_RECIPE__UV_DFP_DATA_FILE),VENDOR_ID=$(_MTB_RECIPE__CMSIS_VENDOR_ID))
	$(call mtb__file_append,$(_MTB_RECIPE__UV_DFP_DATA_FILE),PNAME=$(_MTB_RECIPE__CMSIS_PNAME))

.PHONY: recipe_uvision5_dfp_data_file

##############################################
# EW
##############################################
ifeq ($(MTB_RECIPE__CORE),CM4)
ifneq (,$(_MTB_RECIPE__IS_MULTI_CORE_DEVICE))
_MTB_RECIPE__IAR_CORE_SUFFIX=M4
endif
endif
ifeq ($(MTB_RECIPE__CORE),CM0P)
_MTB_RECIPE__IAR_CORE_SUFFIX=M0+
endif
