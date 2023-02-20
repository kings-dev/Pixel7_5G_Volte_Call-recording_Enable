#!/system/bin/sh
#!/bin/sh
#!/bin/bash
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}
#. MODDIR=${0%/*} ZYGISK_ENABLED 1
# This script will be executed in post-fs-data mode
# More info in the main Magisk thread
##--------------------------------##
country_code_China="86"
carrier_id_China_Mobile="1435"
carrier_id_China_Unicom="1436"
carrier_id_China_Telecom="2237"

cfg_path="/system/vendor/firmware/carrierconfig"
cfg_db_path="/system/vendor/firmware/carrierconfig/cfg.db"

phenotype_path="/data/user/0/com.google.android.gms/databases"
phenotype_db_path="/data/user/0/com.google.android.gms/databases/phenotype.db"

##------------------------------------------------------------------------------##

#######################################################################################################################
##----------------------------------------------------------------------##
phone_iccid_path="/data_mirror/data_de/null/0/com.android.phone/files"
# phone_iccid_path="/data/user_de/0/com.android.phone/files"
no_phone_iccid_name="carrierconfig-com.google.android.carrier-nosim.xml"
##----------------------------------------------------------------------##
iccid_number_12="`service call iphonesubinfo 12 | cut -c 52-66 | tr -d '.[:space:]'`"
iccid_number_13="`service call iphonesubinfo 13 | cut -c 52-66 | tr -d '.[:space:]'`"
##-----------------------------------------------------------------------------------##
iccid_xml_12="`find $phone_iccid_path -name carrierconfig-com.google.android.carrier-"$iccid_number_12"-*.xml`"
iccid_xml_13="`find $phone_iccid_path -name carrierconfig-com.google.android.carrier-"$iccid_number_13"-*.xml`"
iccid_xml_name_12="`basename "$iccid_xml_12"`"
iccid_xml_name_13="`basename "$iccid_xml_13"`"
##-------------------------------------------------------------------------------------------------------------##
echo "customiz.sh"
echo "ICCID_number: $iccid_number_12"
echo "ICCID_number: $iccid_number_13"
echo "ICCID_xml: $iccid_xml_12"
echo "ICCID_xml: $iccid_xml_13"
echo "ICCID_xml_basename: $iccid_xml_name_12"
echo "ICCID_xml_basename: $iccid_xml_name_13"
################################################################
ui_print "> Unzipping sqlite3"
unzip -o "$ZIPFILE" sqlite3 -d $MODDIR >&2
################################################################

################################################################
##------------------------------------------------------------##
cp -rf $cfg_db_path $MODDIR$cfg_db_path
##------------------------------------------------------------##
################################################################
# set_perm  $MODDIR/sqlite3      0     0       0755
################################################################
IFS=$'\n'
# cfg_db_texts=`cat << EOF
cfg_db_texts='
1435
1436
2237
'
# EOF`
# tac_cfg_db_texts="`echo "$cfg_db_texts" | tac`"
tac_cfg_db_texts="`echo "$cfg_db_texts"`"

$MODDIR/sqlite3 -line $MODDIR$cfg_db_path "UPDATE regional_fallback SET country_code = '$country_code_China' , carrier_id = '$carrier_id_China_Mobile'"
for cfg_db_text in $tac_cfg_db_texts
do
	$MODDIR/sqlite3 -line $MODDIR$cfg_db_path "INSERT INTO regional_fallback(country_code,carrier_id) VALUES ('$country_code_China','$cfg_db_text')"
done
$MODDIR/sqlite3 -line $MODDIR$cfg_db_path "DELETE FROM regional_fallback WHERE ROWID NOT IN(select max(rowid) FROM regional_fallback GROUP BY carrier_id)"
$MODDIR/sqlite3 -line $MODDIR$cfg_db_path "SELECT * FROM regional_fallback"

