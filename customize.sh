chmod u+x "$MODPATH/sqlite3"
chmod u+x "$MODPATH/uninstall.sh"
# chmod u+x "$MODPATH/unedit_cfg_phenotype_xml.sh"
##--------------------------------##
country_code_China="0"
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
# phone_iccid_path="/data/user_de/0/com.android.phone/files"
# no_phone_iccid_name="carrierconfig-com.google.android.carrier-nosim.xml"
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
cp -pf $cfg_db_path $MODPATH$cfg_db_path
##------------------------------------------------------------##
mkdir -p $MODPATH$phone_iccid_path
cp -pf $iccid_xml_13 $MODPATH$iccid_xml_13
################################################################
set_pe  $MODPATH/sqlite3      0     0       0755
################################################################
}
copy_cfg_chmod


cfg_db_edit1() {
ui_print "> Attempting cfg.db patch ......"
##---------------------------------------------------------------------------------------------------------------------------------------------------------------##
$MODPATH/sqlite3 -line $MODPATH$cfg_db_path "UPDATE regional_fallback SET country_code = '$country_code_China' , carrier_id = '$carrier_id_China_Mobile'"
$MODPATH/sqlite3 -line $MODPATH$cfg_db_path "INSERT INTO regional_fallback (country_code,carrier_id) VALUES ('$country_code_China','$carrier_id_China_Unicom')"
$MODPATH/sqlite3 -line $MODPATH$cfg_db_path "INSERT INTO regional_fallback (country_code,carrier_id) VALUES ('$country_code_China','$carrier_id_China_Telecom')"
$MODPATH/sqlite3 -line $MODPATH$cfg_db_path "DELETE FROM regional_fallback WHERE ROWID NOT IN(select max(rowid) FROM regional_fallback GROUP BY carrier_id)"
$MODPATH/sqlite3 -line $MODPATH$cfg_db_path "SELECT * FROM regional_fallback"
##---------------------------------------------------------------------------------------------------------------------------------------------------------------##
ui_print "> Attempting cfg.db patch OK^✓^"
}

###################################################################################################################################################################
IFS=$'\n'
# cfg_db_texts=`cat << EOF
cfg_db_texts='
1435
1436
2237
'
# EOF`
tac_cfg_db_texts="`echo "$cfg_db_texts"`"
# tac_cfg_db_texts="`echo "$cfg_db_texts" | tac`"

cfg_db_edit() {
	ui_print "> Attempting cfg.db patch ......"
	$MODPATH/sqlite3 -line $MODPATH$cfg_db_path "UPDATE regional_fallback SET country_code = '$country_code_China' , carrier_id = '$carrier_id_China_Mobile'"
	for cfg_db_text in $tac_cfg_db_texts
	do
		$MODPATH/sqlite3 -line $MODPATH$cfg_db_path "INSERT INTO regional_fallback(country_code,carrier_id) VALUES ('$country_code_China','$cfg_db_text')"
		# $SQLITE $cfg_db_path "INSERT INTO regional_fallback(country_code,carrier_id) VALUES ('$country_code_China','$carrier_id_China_Telecom')"
	done
	$MODPATH/sqlite3 -line $MODPATH$cfg_db_path "DELETE FROM regional_fallback WHERE ROWID NOT IN(select max(rowid) FROM regional_fallback GROUP BY carrier_id)"
	$MODPATH/sqlite3 -line $MODPATH$cfg_db_path "SELECT * FROM regional_fallback"
	ui_print "> Attempting cfg.db patch OK^✓^"
}

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
enable_crosby
'
# EOF`

# Mute the call recording 🔇 replace rename starting_voice-**_**.wav and ending_voice-**_**.wav  *.wav.bak
# wav_path="/data/data/com.google.android.dialer/files/callrecordingprompt"
# for file_name in `ls $wav_path/*.wav`
# do
# mv $file_name `echo $file_name | sed 's/\.wav/\.wav\.bak/'`
# done
#
#btac_FLAGS="`echo "$FLAGS" | tac`"
tac_FLAGS="`echo "$FLAGS"`"

phenotype_db_edit() {
	for FLAG in $tac_FLAGS
	do
    	$MODPATH/sqlite3 -line $phenotype_db_path "INSERT INTO FlagOverrides (packageName, user, name, flagType, boolVal, committed) VALUES ('com.google.android.dialer', '', '$FLAG', 0, 1, 0)"
    	$MODPATH/sqlite3 -line $phenotype_db_path "DELETE FROM FlagOverrides WHERE ROWID NOT IN(select max(rowid) FROM FlagOverrides group by name)"
    done
$MODPATH/sqlite3 -line $phenotype_db_path "SELECT name FROM FlagOverrides"
$MODPATH/sqlite3 -line $phenotype_db_path "SELECT COUNT(*) FROM FlagOverrides"
ui_print "> Attempting phenotype.db patch OK^✓^"
}

phenotype_db_unedit() {
	for FLAG in $tac_FLAGS
	do
		$MODPATH/sqlite3 -line $phenotype_db_path "DELETE FROM FlagOverrides WHERE packageName='com.google.android.dialer' AND name='$FLAG'"
	done
}


##-----------------------------------------------------------------------------------------------------##

ui_print "> Attempting iccid.xml patch ......"
#################################################################################
# input_xml_texts=`cat << EOF
cp -pf $iccid_xml_13 $phone_iccid_path/ICCID_backup_0.xml
ui_print "> ICCID XML backup:ICCID_backup_0.xml"
ui_print "> ICCID XML 备份:ICCID_backup_0.xml"
print_ui_1=`cat $MODPATH$iccid_xml_13 | wc -l`
ui_print "> ICCID XML file line count statistics = $print_ui_1"
ui_print "> ICCID XML 文件行数统计 = $print_ui_1"
#################################################################################
### The content in input_xml_texts_line is a single-line content. 
### Format: 
### input_xml_texts_line='
### xxxxxx'
IFS=$'\n'
input_xml_texts_line='
<boolean name="vonr_enabled_bool" value="true" />
<boolean name="vonr_setting_visibility_bool" value="true" />
<boolean name="vendor_hide_volte_settng_ui" value="false" />
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
'
# EOF`

##-----------------------------tac------------------------------##
tac_input_xml_texts_line="`echo "$input_xml_texts_line" | tac`"
##-----------------------------tac------------------------------##

xml_iccid_edit_line() {

	for input_xml_text_line_f in $tac_input_xml_texts_line
	do
		repeat_xml_line=`grep -n "$(echo "$input_xml_text_line_f")" $MODPATH$iccid_xml_13 | wc -l`
		if [ "$repeat_xml_line" -ge 1 ]
		then
			# echo "单行不写入: $input_xml_text_line_f 重复行数: $repeat_xml_line"
			ui_print "> (Single line does not write|单行不写入): $input_xml_text_line_f (Repeated lines|重复行数): $repeat_xml_line"
			# ui_print "> 单行不写入: $input_xml_text_line_f 重复行数: $repeat_xml_line"
		else
			# echo "单行可写入: $input_xml_text_line_f"
			ui_print "> (Single line writable|单行可写入): $input_xml_text_line_f"
			# ui_print "> 单行可写入: $input_xml_text_line_f"
			sed -i "1a `echo "$input_xml_text_line_f"`" $MODPATH$iccid_xml_13
		fi
    done
}
################################################################################################

################################################################################################
### Replace multiple lines of consecutive associated content.
### Format: 
### input_xml_texts_lines='
### 11111x
### 22222x
### 33333x'
### !!! Note that the current script only supports a set of multi-line consecutive internal heat checks and replaces.
IFS=$'\n'
input_xml_texts_lines='
<int-array name="carrier_nr_availabilities_int_array" num="2">
<item value="1" />
<item value="2" />
</int-array>
'

# 反序输出
tac_input_xml_texts_lines="`echo "$input_xml_texts_lines" | tac`"
#echo "$tac_input_xml_texts_lines"
# 反序没有换行符
tac_input_xml_texts_lines_d="`echo "$input_xml_texts_lines" | tac`"
# echo $tac_input_xml_texts_lines_d
# 正序没有换行符
no_tac_input_xml_texts_lines="`echo $input_xml_texts_lines`"
# echo $no_tac_input_xml_texts_lines
# 正序输出
no_tac_input_xml_texts_lines_d="`echo "$input_xml_texts_lines"`"
# echo "$no_tac_input_xml_texts_lines_d"
### sed -e '/1/{N;s/22/22?/;N;s/333/333ok/}' $MODPATH$iccid_xml_13
### sed ':a; N; $!ba; s/\n//g' file.txt
xml_iccid_edit_lines() {

	for input_xml_text_lines_f in $tac_input_xml_texts_lines
	do
		repeat_xml_lines=`echo $(cat $MODPATH$iccid_xml_13) | grep -o "$no_tac_input_xml_texts_lines" | wc -l`
		if [ "$repeat_xml_lines" -ge 1 ]
		then
			# echo "多行不写入: $input_xml_text_lines_f 重复行数: $repeat_xml_lines"
			ui_print "> (Multiple lines are not written|多行不写入): $input_xml_text_lines_f (Repeated lines|重复行数): $repeat_xml_lines"
			# ui_print "> 多行不写入: $input_xml_text_lines_f 重复行数: $repeat_xml_lines"
		else
			# echo "多行可写入: $input_xml_text_lines_f"
			ui_print "> (Multiple lines can be written|多行可写入): $input_xml_text_lines_f"
			# ui_print "> 多行可写入: $input_xml_text_lines_f"
			sed -i "1a `echo "$input_xml_text_lines_f"`" $MODPATH$iccid_xml_13
		fi
	done
}


################################################################################################
# xml_iccid_edit_line
# xml_iccid_edit_lines
################################################################################################
unxml_iccid_edit_line() {

	for input_xml_texts_line_unedit in $tac_input_xml_texts_line
	do
		repeat_unxml_line=`grep -n "$(echo "$input_xml_texts_line_unedit")" $MODPATH$iccid_xml_13 | wc -l`
		if [ "$repeat_unxml_line" -eq 1 ]
		then
			input_xml_unedit="`echo "$input_xml_texts_line_unedit" | sed 's/\//\\\\\//g'`"
			sed -i "/`echo "$input_xml_unedit"`/d" $MODPATH$iccid_xml_13
			# echo "单行可删除: $input_xml_texts_line_unedit"
			ui_print "> (Single line can be deleted|单行可删除):$input_xml_texts_line_unedit"
			# ui_print "> 单行可删除: $input_xml_texts_line_unedit"
		else
			# echo "单行不删除: $input_xml_texts_line_unedit 重复行数: $repeat_unxml_line"
			ui_print "> (Single line is not deleted|单行不可删除): $input_xml_texts_line_unedit (Repeated lines|重复行数): $repeat_unxml_line"
			# ui_print "> 单行不删除: $input_xml_texts_line_unedit 重复行数: $repeat_unxml_line"
		fi
    done
}
################################################################################################

################################################################################################
###换行符转义：\n
# sed ':a;N;$!ba;s/\n/\\n/g' $MODPATH$iccid_xml_13
###转义换行符：真正回车
# vfalse：#sed ':a; N; $!ba; s/\\n/\n/g' $MODPATH$iccid_xml_13
# sed 's/\\n/\n/g' $MODPATH$iccid_xml_13

# 替换连续多行：
# 先把内容回车转义，在把查找内容转义，再替换，再转义回真正回车。

unxml_iccid_edit_lines() {

	repeat_unxml_lines=`echo $(cat $MODPATH$iccid_xml_13) | grep -o "$no_tac_input_xml_texts_lines" | wc -l`
	if [ "$repeat_unxml_lines" -eq 1 ]
	then
# 		input_xml_unedits="`echo "$no_tac_input_xml_texts_lines" | sed 's/\//\\\\\//g'`"
# 		sed -i "/`echo "$input_xml_unedits"`/d" $MODPATH$iccid_xml_13
		# echo "多行可删除: $no_tac_input_xml_texts_lines_d"
		ui_print "> (Multiple lines can be deleted|多行可删除):$no_tac_input_xml_texts_lines_d"
		# ui_print "> 多行可删除: $no_tac_input_xml_texts_lines_d"
		#xml文件转义
		n_unxml_lines=$(echo $(sed ':a;N;$!ba;s/\n/oko/g' $MODPATH$iccid_xml_13))
		# 这里不可以使用`$()`否则没有\n
		# echo -e $n_unxml_lines
		# 搜索内容转义
		t_unxml_lines=$(echo "$input_xml_texts_lines"|sed ':a;N;$!ba;s/\n/oko/g')
		# echo $t_unxml_lines
# 		oko=$(echo $n_unxml_lines |sed s#$t_unxml_lines##g)
		okok=$(echo $t_unxml_lines|sed 's/^...//'|sed 's/...$//')
		okokok=$(echo $n_unxml_lines |sed "s#$okok##g"|sed 's/oko/\n/g'|sed '/^$/d')
		echo -e "$okokok" > $MODPATH$iccid_xml_13
		# rm -f $MODPATH$iccid_xml_13.swp
	else
		#echo "多行不删除！！！！！！: $no_tac_input_xml_texts_lines_d 重复行数: $repeat_unxml_lines"
		ui_print "> (Do not delete multiple lines|多行不删除): $no_tac_input_xml_texts_lines_d (Repeated lines|重复行数): $repeat_unxml_lines"
		# ui_print "> 多行不删除: $no_tac_input_xml_texts_lines_d 重复行数: $repeat_unxml_lines"
	fi
}
################################################################################################
# unxml_iccid_edit_line
# unxml_iccid_edit_lines
################################################################################################
################################################################################################
# unxml_iccid_edit_lines() {
#
# 	for input_xml_texts_lines_unedit in $tac_input_xml_texts_lines
# 	do
# 		repeat_unxml_lines=`grep -n "$(echo "$input_xml_texts_lines_unedit")" $MODPATH$iccid_xml_13 | wc -l`
# 		if [ "$repeat_unxml_lines" -eq 1 ]
# 		then
# 			input_xml_unedits="`echo "$input_xml_texts_lines_unedit" | sed 's/\//\\\\\//g'`"
# 			sed -i "/`echo "$input_xml_unedits"`/d" $MODPATH$iccid_xml_13
# 			echo "多行可删除: $input_xml_texts_lines_unedit"
# 		else
# 			echo "多行不删除: $input_xml_texts_lines_unedit 重复行数: $repeat_unxml_lines"
# 		fi
#     done
# }

# ###换行符转义：\n
# sed ':a;N;$!ba;s/\n/\\n/g' $MODPATH$iccid_xml_13
# ###转义换行符：真正回车
# #false：#sed ':a; N; $!ba; s/\\n/\n/g' $MODPATH$iccid_xml_13
# sed 's/\\n/\n/g' $MODPATH$iccid_xml_13
#
# unxml_iccid_edit_lines() {
# 	for input_xml_texts_lines_unedit in $tac_input_xml_texts_lines
# 	do
# 		texts_number=`echo "$tac_input_xml_texts_lines"|wc -l`
# 		repeat_unxml_lines=`grep -n "$(echo "$input_xml_texts_lines_unedit")" $MODPATH$iccid_xml_13 |awk -F : '{print $1}'`
# 		echo "$repeat_unxml_lines"
# 		if [ "$repeat_unxml_lines" -eq 1 ]
# 		then
# # 			input_xml_unedits="`echo "$no_tac_input_xml_texts_lines" | sed 's/\//\\\\\//g'`"
# # 			sed -i "/`echo "$input_xml_unedits"`/d" $MODPATH$iccid_xml_13
# 			echo "多行可删除: $input_xml_texts_lines_unedit"
#
# 		else
# 			echo "多行不删除: $input_xml_texts_lines_unedit 重复行数: $repeat_unxml_lines"
# 		fi
# 	done
# }
#
################################################################################################
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
# 		sed -i ""$xml"a `echo "$input_xml_text"`" "$MODPATH$iccid_xml_13"
# 	done
# done
##----------------------------number----------------------------##
#ui_print "> Attempting iccid.xml patch OK^✓^"
################################################################################################

##------------------------------------------------------------##
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
###*^÷^**^÷^**^÷^**^÷^**^÷^**^÷^**^÷^**^÷^*###
###*^÷^**^÷^**^÷^**^÷^**^÷^*
# echo 'xml_iccid_unedit' >> $phone_iccid_path/xml_edit_bashshell.sh
# chmod u+x "$phone_iccid_path/xml_edit_bashshell.sh"
# sh $phone_iccid_path/xml_edit_bashshell.sh
cfg_db_unedit
cfg_db_edit
phenotype_db_unedit
phenotype_db_edit
chmod radio:radio $MODPATH$iccid_xml_13
chmod 0600 $MODPATH$iccid_xml_13
# md5sum $iccid_xml_13 | awk '{print $1}' >> $phone_iccid_path/md5sum.xml
md5sum $MODPATH$iccid_xml_13 | awk '{print $1}' >> $MODPATH$phone_iccid_path/md5sum_0.xml
unxml_iccid_edit_line
unxml_iccid_edit_lines
sleep 0.2
# md5sum $iccid_xml_13 | awk '{print $1}' >> $phone_iccid_path/md5sum.xml
md5sum $MODPATH$iccid_xml_13 | awk '{print $1}' >> $MODPATH$phone_iccid_path/md5sum_0.xml
xml_iccid_edit_line
xml_iccid_edit_lines
# md5sum $iccid_xml_13 | awk '{print $1}' >> $phone_iccid_path/md5sum.xml
md5sum $MODPATH$iccid_xml_13 | awk '{print $1}' >> $MODPATH$phone_iccid_path/md5sum_0.xml
chmod radio:radio $MODPATH$iccid_xml_13
chmod 0600 $MODPATH$iccid_xml_13
###*^÷^**^÷^**^÷^**^÷^**^÷^*
###*^÷^**^÷^**^÷^**^÷^**^÷^**^÷^**^÷^**^÷^*###

sed -i '/^$/d' $MODPATH$iccid_xml_13

cp -pf $MODPATH$iccid_xml_13 $iccid_xml_13
sleep 0.4
chmod radio:radio $iccid_xml_13
chmod 0600 $iccid_xml_13

print_ui_0=`cat $MODPATH$iccid_xml_13 | wc -l`

# echo "修改行数: $print_ui_0 - $print_ui_1 = $(( print_ui_0 - print_ui_1 ))"
ui_print "> (Modify the number of lines|修改行数): $print_ui_0 - $print_ui_1 = $(( print_ui_0 - print_ui_1 ))"
#ui_print "> 修改行数: $print_ui_0 - $print_ui_1 = $(( print_ui_0 - print_ui_1 ))"

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
# Construct your own list here, it will override the example above
# !DO NOT! remove this if you don't need to replace anything, leave it empty as it is now
##------------------------------------------------------------##

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
  set_perm $MODPATH$iccid_xml_13	1001	1001	0400
  #set_perm $iccid_xml_13	1001	1001	0400
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

