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

MTB_RECIPE__IDE_SUPPORTED:=eclipse vscode uvision5 ewarm8

include $(MTB_TOOLS__RECIPE_DIR)/make/recipe/interface_version_1/recipe_ide_common.mk

ifeq ($(filter vscode,$(MAKECMDGOALS)),vscode)

CY_VSCODE_JSON_PROCESSING=\
	if [[ $$jsonFile == "launch.json" ]]; then\
		if [[ $(_MTB_RECIPE__OPENOCD_CHIP_NAME) == "psoc64" ]]; then\
			grep -v "//PSoC6 Only//" $(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile >\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile;\
			sed -e 's/\/\/PSoC64 Only\/\///g' $(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile >\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile;\
		else\
			grep -v "//PSoC64 Only//" $(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile >\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile;\
			sed -e 's/\/\/PSoC6 Only\/\///g' $(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile >\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile;\
		fi;\
		if [[ "$(MTB_TYPE)" == "PROJECT" ]]; then\
			sed -e '/\/\/Except multi-core start\/\//,/\/\/Except multi-core end\/\//d'\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile >\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile;\
		else\
			sed -e 's/\/\/Except multi-core start\/\///g' -e 's/\/\/Except multi-core end\/\///g'\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile >\
				$(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile;\
		fi;\
		mv -f $(CY_VSCODE_OUT_TEMPLATE_PATH)/__$$jsonFile $(CY_VSCODE_OUT_TEMPLATE_PATH)/$$jsonFile;\
	fi;

CY_VSCODE_OPENOCD_PROCESSING=\
	if [[ $(_MTB_RECIPE__OPENOCD_CHIP_NAME) != "psoc64" ]]; then\
		grep -v "set TARGET_AP cm4_ap" $(CY_VSCODE_OUT_PATH)/openocd.tcl > $(CY_VSCODE_OUT_PATH)/_openocd.tcl;\
		mv -f $(CY_VSCODE_OUT_PATH)/_openocd.tcl $(CY_VSCODE_OUT_PATH)/openocd.tcl;\
	fi;\
	if [[ "$(_MTB_RECIPE__IS_MULTI_CORE_DEVICE)" == "true" ]]; then\
		grep -v "set ENABLE_CM0 0" $(CY_VSCODE_OUT_PATH)/openocd.tcl > $(CY_VSCODE_OUT_PATH)/_openocd.tcl;\
		mv -f $(CY_VSCODE_OUT_PATH)/_openocd.tcl $(CY_VSCODE_OUT_PATH)/openocd.tcl;\
	fi;\

$(MTB_RECIPE__IDE_RECIPE_DATA_FILE)_vscode:
	$(MTB__NOISE)echo "s|&&_MTB_RECIPE__DEVICE_PROGRAM&&|$(_MTB_RECIPE__JLINK_DEVICE_CFG_PROGRAM)|g;" > $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__DEVICE_DEBUG&&|$(_MTB_RECIPE__JLINK_DEVICE_CFG_DEBUG)|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__OPENOCD_CHIP&&|$(_MTB_RECIPE__OPENOCD_CHIP_NAME)|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__QSPI_CFG_PATH&&|$(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH)|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__QSPI_CFG_PATH_APPLICATION&&|$(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH_APPLICATION)|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__FIRST_APP_NAME&&|$(firstword $(MTB_APPLICATION_SUBPROJECTS))|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__SECOND_APP_NAME&&|$(lastword $(MTB_APPLICATION_SUBPROJECTS))|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);
ifeq ($(MTB_RECIPE__CORE),CM0P)
	$(MTB__NOISE)echo "s|&&_MTB_RECIPE__TARGET_PROCESSOR_NAME&&|CM0+|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__TARGET_PROCESSOR_NUMBER&&|0|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__PROCESSOR_COUNT&&|2|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);
else
ifeq (,$(_MTB_RECIPE__IS_MULTI_CORE_DEVICE))
	$(MTB__NOISE)echo "s|&&_MTB_RECIPE__TARGET_PROCESSOR_NAME&&|CM4|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__TARGET_PROCESSOR_NUMBER&&|0|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__PROCESSOR_COUNT&&|1|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);
else
	$(MTB__NOISE)echo "s|&&_MTB_RECIPE__TARGET_PROCESSOR_NAME&&|CM4|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__TARGET_PROCESSOR_NUMBER&&|1|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);\
	echo "s|&&_MTB_RECIPE__PROCESSOR_COUNT&&|2|g;" >> $(MTB_RECIPE__IDE_RECIPE_DATA_FILE);
endif #ifeq (,$(_MTB_RECIPE__IS_MULTI_CORE_DEVICE))
endif #ifeq ($(MTB_RECIPE__CORE),CM0P)
endif #ifeq ($(filter vscode,$(MAKECMDGOALS)),vscode)

ifeq ($(MTB_RECIPE__CORE),CM4)
ifneq (,$(_MTB_RECIPE__IS_MULTI_CORE_DEVICE))
_MTB_RECIPE__IAR_CORE_SUFFIX=M4
endif
endif
ifeq ($(MTB_RECIPE__CORE),CM0P)
_MTB_RECIPE__IAR_CORE_SUFFIX=M0+
endif

ewarm8_recipe_data_file:
	$(call mtb__file_write,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),$(DEVICE)$(_MTB_RECIPE__IAR_CORE_SUFFIX))

ewarm8: ewarm8_recipe_data_file

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

_MTB_RECIPE__CMSIS_LDFLAGS:=

uvision5_recipe_data_file:
	$(call mtb__file_write,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),$(_MTB_RECIPE__CMSIS_ARCH_NAME))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),$(_MTB_RECIPE__CMSIS_VENDOR_NAME))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),$(_MTB_RECIPE__CMSIS_VENDOR_ID))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),$(_MTB_RECIPE__CMSIS_PNAME))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),$(_MTB_RECIPE__CMSIS_LDFLAGS))

uvision5: uvision5_recipe_data_file

MTB_RECIPE_VSCODE_TEMPLATE_SUBDIR=CMx/
ifeq ($(filter eclipse,$(MAKECMDGOALS)),eclipse)

# For multi-core application a set of launch configurations is a bit different.
# To handle this, copy templates into a separate folder and remove extra configurations
_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR:=$(MTB_TOOLS__OUTPUT_CONFIG_DIR)/template_dir
_MTB_RECIPE__ECLIPSE_TEMPLATE_SUBDIR:=$(MTB_RECIPE__CORE)

eclipse_recipe_template_dir:
	$(CY_NOISE)if [[ "$(_MTB_RECIPE__IS_MULTI_CORE_APPLICATION)" == "true" ]]; then\
		if [ -d $(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR) ]; then\
			rm -f -r $(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR);\
		fi;\
		mkdir $(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR);\
		cp -r "$(MTB_TOOLS__RECIPE_DIR)/make/scripts/interface_version_1/eclipse/$(_MTB_RECIPE__ECLIPSE_TEMPLATE_SUBDIR)" "$(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR)";\
		cp -r "$(MTB_TOOLS__RECIPE_DIR)/make/scripts/interface_version_1/eclipse/Application" "$(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR)";\
		rm "$(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR)/$(_MTB_RECIPE__ECLIPSE_TEMPLATE_SUBDIR)/Erase"*;\
		rm "$(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR)/$(_MTB_RECIPE__ECLIPSE_TEMPLATE_SUBDIR)/Program"*;\
		configPath=$$($(MTB__FIND) $(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR)/Application -name "Add CM4 to CM0+"*);\
		configName=$$(basename "$$configPath");\
		if [[ $(MTB_RECIPE__CORE) == "CM4" ]]; then\
			mv -f "$$configPath" "$(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR)/CM4/$$configName";\
		else\
			rm "$$configPath";\
		fi;\
	fi;

eclipse_recipe_template_dir_clean: | eclipse_generate
	$(CY_NOISE)if [[ "$(_MTB_RECIPE__IS_MULTI_CORE_APPLICATION)" == "true" ]]; then\
		rm -f -r "$(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR)";\
	fi;

eclipse_generate: eclipse_recipe_template_dir
eclipse: eclipse_recipe_template_dir_clean

eclipse_textdata_file:
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__OPENOCD_SECOND_RESET&&=$(_MTB_RECIPE__OPENOCD_SECOND_RESET_TYPE))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__OPENOCD_RUN_RESTART_DEBUG_CMD&&=$(_MTB_RECIPE__OPENOCD_RUN_RESTART_CMD_DEBUG_ECLIPSE))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__OPENOCD_RUN_RESTART_ATTACH_CMD&&=$(_MTB_RECIPE__OPENOCD_RUN_RESTART_CMD_ATTACH_ECLIPSE))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__OPENOCD_SHELL_TIMEOUT&&=$(CY_OPENOCD_SHELL_TIMEOUT_ECLIPSE))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__JLINK_CFG_PROGRAM&&=$(_MTB_RECIPE__JLINK_DEVICE_CFG_PROGRAM))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__JLINK_CFG_DEBUG&&=$(_MTB_RECIPE__JLINK_DEVICE_CFG_DEBUG))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__JLINK_CFG_ATTACH&&=$(_MTB_RECIPE__JLINK_DEVICE_CFG_ATTACH))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__OPENOCD_PORT_SELECT&&=$(_MTB_RECIPE__OPENOCD_EXTRA_PORT_ECLIPSE))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__OPENOCD_CM0_FLAG&&=$(_MTB_RECIPE__OPENOCD_CM0_DISABLE_ECLIPSE))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__OPENOCD_SMIF_DISABLE&&=$(_MTB_RECIPE__OPENOCD_SMIF_DISABLE_ECLIPSE))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__CORE&&=$(_MTB_RECIPE__OPENOCD_CORE))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__QSPI_CFG_PATH&&=$(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH_WITH_FLAG))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__QSPI_CFG_PATH_APPLICATION&&=$(_MTB_RECIPE__OPENOCD_QSPI_CFG_PATH_APPLICATION_WITH_FLAG))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__FIRST_APP_NAME&&=$(firstword $(MTB_APPLICATION_SUBPROJECTS)))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__SECOND_APP_NAME&&=$(lastword $(MTB_APPLICATION_SUBPROJECTS)))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_DATA_FILE),&&_MTB_RECIPE__APPNAME&&=$(_MTB_ECLIPSE_PROJECT_NAME))

ifeq ($(_MTB_RECIPE__IS_MULTI_CORE_APPLICATION),true)
_MTB_ECLIPSE_TEMPLATE_RECIPE_SEARCH:=$(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR)/$(_MTB_RECIPE__ECLIPSE_TEMPLATE_SUBDIR)
_MTB_ECLIPSE_TEMPLATE_RECIPE_APP_SEARCH:=$(_MTB_RECIPE__ECLIPSE_TEMPLATE_DIR)/Application
else
_MTB_ECLIPSE_TEMPLATE_RECIPE_SEARCH:=$(MTB_TOOLS__RECIPE_DIR)/make/scripts/interface_version_1/eclipse/$(_MTB_RECIPE__ECLIPSE_TEMPLATE_SUBDIR)
_MTB_ECLIPSE_TEMPLATE_RECIPE_APP_SEARCH:=
endif

eclipse_recipe_metadata_file:
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_METADATA_FILE),RECIPE_TEMPLATE=$(_MTB_ECLIPSE_TEMPLATE_RECIPE_SEARCH))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_METADATA_FILE),RECIPE_APP_TEMPLATE=$(_MTB_ECLIPSE_TEMPLATE_RECIPE_APP_SEARCH))
	$(call mtb__file_append,$(MTB_RECIPE__IDE_RECIPE_METADATA_FILE),PROJECT_UUID=&&PROJECT_UUID_$(MTB_RECIPE__CORE_NAME)&&)

endif
