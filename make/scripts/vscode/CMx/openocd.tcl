source [find interface/kitprog3.cfg]
transport select swd
set TARGET_AP cm4_ap
set ENABLE_CM0 0
source [find target/&&_MTB_RECIPE__OPEN_OCD_FILE&&]
${TARGET}.cm4 configure -rtos auto -rtos-wipe-on-reset-halt 1
psoc6 sflash_restrictions 1
