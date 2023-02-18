#!/system/bin/sh
#!/bin/sh
#!/bin/bash
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}
MODDIR=${0%/*} ZYGISK_ENABLED 1
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
mkdir -p $MODDIR$cfg_path
cp -rf $cfg_db_path $MODDIR$cfg_db_path
##------------------------------------------------------------##

################################################################
set_perm  $MODDIR/sqlite3      0     0       0755
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


# FLAGS=`cat << EOF
FLAGS='
G__enable_call_recording
G__force_within_call_recording_geofence_value
G__use_call_recording_geofence_overrides
G__force_within_crosby_geofence_value
G__enable_atlas
G__speak_easy_enabled
G__enable_speakeasy_details
G__speak_easy_bypass_locale_check
G__speak_easy_enable_listen_in_button
'
# EOF`
#tac_FLAGS="`echo "$FLAGS" | tac`"
tac_FLAGS="`echo "$FLAGS"`"

for FLAG in $tac_FLAGS
do
    $MODDIR/sqlite3 -line $phenotype_db_path "INSERT INTO FlagOverrides (packageName, user, name, flagType, boolVal, committed) VALUES ('com.google.android.dialer', '', '$FLAG', 0, 1, 0)"
    $MODDIR/sqlite3 -line $phenotype_db_path "DELETE FROM FlagOverrides WHERE ROWID NOT IN(select max(rowid) FROM FlagOverrides group by name)"
done
$MODDIR/sqlite3 -line $phenotype_db_path "SELECT name FROM FlagOverrides"
$MODDIR/sqlite3 -line $phenotype_db_path "SELECT COUNT(*) FROM FlagOverrides"

##-----------------------------------------------------------------------------------------------------##
IFS=$'\n'
# input_xml_texts=`cat << EOF
input_xml_texts='
<boolean name="vonr_enabled_bool" value="true" />
<boolean name="vonr_setting_visibility_bool" value="true" />
<boolean name="editable_enhanced_4g_lte_bool" value="true" />
<boolean name="editable_wfc_mode_bool" value="true" />
<boolean name="enhanced_4g_lte_title_variant_bool" value="true" />
<int name="enhanced_4g_lte_title_variant_int" value="1" />
<boolean name="enhanced_4g_lte_on_by_default_bool" value="true" />
<boolean name="hide_enhanced_4g_lte_bool" value="false" />
<int name="lte_plus_threshold_bandwidth_khz_int" value="1" />
<int name="nr_advanced_threshold_bandwidth_khz_int" value="1" />
<boolean name="hide_lte_plus_data_icon_bool" value="true" />
<boolean name="lte_enabled_bool" value="true" />
<boolean name="show_data_connected_roaming_notification" value="true" />
<boolean name="show_carrier_data_icon_pattern_string" value="true" />
<boolean name="carrier_volte_available_bool" value="true" />
<boolean name="carrier_default_wfc_ims_enabled_bool" value="true" />
<boolean name="carrier_wfc_ims_available_bool" value="true" />
<boolean name="carrier_vt_available_bool" value="true" />
<boolean name="carrier_supports_ss_over_ut_bool" value="true" />
<boolean name="carrier_cross_sim_ims_available_bool" value="true" />
<int-array name="carrier_nr_availabilities_int_array" num="2">
<item value="1" />
<item value="2" />
</int-array>
'
# EOF`
##-----------------------------tac------------------------##
tac_input_xml_texts="`echo "$input_xml_texts" | tac`"

for input_xml_text in $tac_input_xml_texts
do
    sed -i "1a `echo "$input_xml_text"`" $iccid_xml_13
done
##-----------------------------tac------------------------##

##----------------------------number----------------------------##
# xml="0"
# xml_number="`echo "$input_xml_texts" | wc -l`"
# echo "行数: $xml_number"
# while [ "$xml" -lt "$xml_number" ]
# do
# 	for input_xml_text in $input_xml_texts
# 	do
# 		((xml=xml+1))
# 		echo "$xml"
# 		sed -i ""$xml"a `echo "$input_xml_text"`" "$MODDIR$iccid_xml_13"
# 	done
# done
##----------------------------number----------------------------##

