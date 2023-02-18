#!/system/bin/sh
MODDIR=${0%/*}
#MODPATH=${0%/*} ZYGISK_ENABLED 1

. $MODDIR/unedit_cfg_phenotype_xml.sh

# Currently it's not working. Because PHENOTYPE_PATH is not accessible during uninstall stage. And I don't know how to deal with it.
settings put global guest_user_enabled 1