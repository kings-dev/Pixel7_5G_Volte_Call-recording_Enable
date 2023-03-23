##--------------------------------##
country_code_China="86"
carrier_id_China_Mobile="1435"
carrier_id_China_Unicom="1436"
carrier_id_China_Telecom="2237"

cfg_path="/system/vendor/firmware/carrierconfig"
cfg_db_path="/system/vendor/firmware/carrierconfig/cfg.db"

phenotype_path="/data/user/0/com.google.android.gms/databases"
phenotype_db_path="/data/user/0/com.google.android.gms/databases/phenotype.db"

ui_print "> find iccid start ......customiz.sh"
##------------------------------------------------------------------------------##

#######################################################################################################################
##----------------------------------------------------------------------##
phone_iccid_path="/data_mirror/data_de/null/0/com.android.phone/files"
#phone_iccid_path="/data/user_de/0/com.android.phone/files"
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

ui_print "> find iccid OK"
#######################################################################################################################

##########################################################################################

##########################################################################################
#
# Magisk Module Template Config Script
# by topjohnwu
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure the settings in this file (config.sh)
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Configs
##########################################################################################

# Set to true if you need to enable Magic Mount
# Most mods would like it to be enabled
AUTOMOUNT=true

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=false

##########################################################################################
# editation Message
##########################################################################################

# Set what you want to show when editing your mod

print_modname() {
  ui_print "> ================================================="
  ui_print "> Pixel_7 Kings_DEV cfg.db & phenotype.db  patcher."
  ui_print "> ================================================="
}

copy_cfg_chmod() {
################################################################
ui_print "> Unzipping sqlite3"
unzip -o "$ZIPFILE" sqlite3 -d $MODPATH >&2
################################################################

################################################################
ui_print "> Copying stock cfg.db & phenotype.db."
##------------------------------------------------------------##
mkdir -p $MODPATH$cfg_path
cp $cfg_db_path $MODPATH$cfg_db_path
##------------------------------------------------------------##

################################################################
set_perm  $MODPATH/sqlite3      0     0       0755
################################################################
}

###################################################################################################################################################################
IFS=$'\n'
# cfg_db_texts=`cat << EOF
cfg_db_texts='
2237
1436
1435
'
# EOF`
tac_cfg_db_texts="`echo "$cfg_db_texts" | tac`"

cfg_db_unedit() {
	for cfg_db_text in $cfg_db_texts
	do
		$MODPATH/sqlite3 -line $MODPATH$cfg_db_path "DELETE FROM regional_fallback WHERE country_code='$country_code_China' AND carrier_id='$cfg_db_text'"
	done
}


ui_print "> Attempting phenotype.db patch ......"
IFS=$'\n'
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
tac_FLAGS="`echo "$FLAGS" | tac`"

phenotype_db_unedit() {
	for FLAG in $tac_FLAGS
	do
		$MODPATH/sqlite3 -line $phenotype_db_path "DELETE FROM FlagOverrides WHERE packageName='com.google.android.dialer' AND name='$FLAG'"
	done
}



##-----------------------------------------------------------------------------------------------------##

	
ui_print "> Attempting iccid.xml patch ......"

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

xml_iccid_unedit() {
	for input_xml_text in $tac_input_xml_texts
	do
    	input_xml_untext="`echo "$input_xml_text" | sed 's/\//\\\\\//g'`"
    	sed -i "/`echo "$input_xml_untext"`/d" $iccid_xml_13
    done
}

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info about how Magic Mount works, and why you need this

# This is an example
##------------------------------------------------------------##
# $cfg_path
# $phenotype_path
# $phone_iccid_path


REPLACE="
/system/vendor/firmware/carrierconfig
"

REPLACE="
"
##------------------------------------------------------------##
copy_cfg_chmod
cfg_db_unedit
phenotype_db_unedit
chmod 0600 $iccid_xml_13
xml_iccid_unedit
##------------------------------------------------------------##
if [ ! -f "$MODPATH$cfg_db_path" ]; then
  ui_print "> $MODPATH$cfg_db_path doesn't exist"
  abort "> Module editation failure : cfg_db_path"
fi
##------------------------------------------------------------##

##------------------------------------------------------------##
if [ ! -f "$phenotype_db_path" ]; then
  ui_print "> $phenotype_db_path doesn't exist"
  abort "> Module editation failure : phenotype_path"
fi
##------------------------------------------------------------##
# Construct your own list here, it will override the example above
# !DO NOT! remove this if you don't need to replace anything, leave it empty as it is now
##------------------------------------------------------------##

# REPLACE="
# "

##------------------------------------------------------------##


##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  # Only some special files require specific permissions
  # The default permissions should be good enough for most cases

  # Here are some examples for the set_perm functions:

  # set_perm_recursive  <dirname>                <owner> <group> <dirpermission> <filepermission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm_recursive  $MODPATH$phenotype_path        10141   10141   0771   0660
  # set_perm_recursive  $MODPATH$phone_iccid_path      1001	1001	0771   0600
  # set_perm_recursive  $MODPATH$cfg_path	0	   2000	0755   0644
  
  # set_perm  <filename>                         <owner> <group> <permission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm  $MODPATH/system/bin/app_process32   0       2000    0755         u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0       2000    0755         u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0       0       0644

  # The following is default permissions, DO NOT remove
  set_perm_recursive  $MODPATH  0  0  0755  0644
  # set_perm_recursive $MODPATH	0	0	0755
  # set_perm_recursive $MODPATH$cfg_path	0	2000	0755	0644
  #set_perm_recursive $MODPATH$phenotype_path	10122	10122	0771	0660
  #set_perm_recursive $MODPATH$phone_iccid_path	1001	1001	0771	0600
  #set_perm $MODPATH$cfg_db_path	0	0	0644
  #set_perm $MODPATH$phenotype_db_path	10122	10122	0660
  #set_perm $MODPATH$iccid_xml_13	1001	1001	0600
}
# set_permissions

##########################################################################################
# Custom Functions
##########################################################################################

# This file (config.sh) will be sourced by the main flash script after util_functions.sh
# If you need custom logic, please add them here as functions, and call these functions in
# update-binary. Refrain from adding code directly into update-binary, as it will make it
# difficult for you to migrate your modules to newer template versions.
# Make update-binary as clean as possible, try to only do function calls in it.

