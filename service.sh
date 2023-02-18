#!/system/bin/sh
cat << "EOF" > $phone_iccid_path/xml_edit_bashshell.sh
#!/bin/bash
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

xml_iccid_edit() {
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
# 		sed -i ""$xml"a `echo "$input_xml_text"`" "$MODPATH$iccid_xml_13"
# 	done
# done
##----------------------------number----------------------------##
ui_print "> Attempting iccid.xml patch OK^✓^"
}

xml_iccid_unedit() {
	for input_xml_text in $tac_input_xml_texts
	do
    	input_xml_untext="`echo "$input_xml_text" | sed 's/\//\\\\\//g'`"
    	sed -i "/`echo "$input_xml_untext"`/d" $iccid_xml_13
    done
}
EOF
chmod 0600 $iccid_xml_13
echo 'xml_iccid_unedit' >> $phone_iccid_path/xml_edit_bashshell.sh
chmod u+x "$phone_iccid_path/xml_edit_bashshell.sh"
#echo 'xml_iccid_edit' >> $phone_iccid_path/xml_edit_bashshell.sh
sh $phone_iccid_path/xml_edit_bashshell.sh
chmod 0400 $iccid_xml_13