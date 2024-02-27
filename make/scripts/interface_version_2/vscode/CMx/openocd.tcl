source [find interface/kitprog3.cfg]
transport select swd
&&_MTB_RECIPE__OPENOCD_PSOC6_TARGET_AP&&
&&_MTB_RECIPE__OPENOCD_ENABLE_CM0&&
source [find target/&&_MTB_RECIPE__OPEN_OCD_FILE&&]
${TARGET}.&&_MTB_RECIPE__OPENOCD_CORE&& configure -rtos auto -rtos-wipe-on-reset-halt 1
&&_MTB_RECIPE__OPENOCD_MONITOR_CMDS_NAME&& sflash_restrictions 1
