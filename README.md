# Piexl7_5G_Volte_Call-recording_Enable  
piexl 7 5G vlote Call recording enable  
Turn on VO5G, wifi, and record calls. The premise requires the Network Signal Master app to turn on 5G.  
#######################################################################################################  
# The code is cfg.db for china.  
country_code_China="86"  
carrier_id_China_Mobile="1435"  
carrier_id_China_Unicom="1436"  
carrier_id_China_Telecom="2237"  
#################################  
country_code_China="0"        Please modify :"Your country_code" or "0",Recommendation "0".  
carrier_id_China_Mobile="?"   Please modify :"Your carrier_id" or Comment the line "#"  
carrier_id_China_Unicom="?"   Please modify :"Your carrier_id" or Comment the line "#"  
carrier_id_China_Telecom="?"  Please modify :"Your carrier_id" or Comment the line "#"  
cfg_db_texts='  
1435  
1436  
2237  
'  
# cfg_db_path="/system/vendor/firmware/carrierconfig/cfg.db"  
#######################################################################################################
# The code is phenotype.db  
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
phenotype_db_path="/data/user/0/com.google.android.gms/databases/phenotype.db"  
#######################################################################################################  
# The code is carrierconfig-com.google.android.carrier-xxxx-xxxx.xml  
input_xml_texts_line='  
<boolean name="vonr_enabled_bool" value="true" \/>  
<boolean name="vonr_setting_visibility_bool" value="true" \/>  
<boolean name="vendor_hide_volte_settng_ui" value="false" \/>  
<boolean name="editable_enhanced_4g_lte_bool" value="true" \/>  
<boolean name="editable_wfc_mode_bool" value="true" \/>  
<boolean name="enhanced_4g_lte_title_variant_bool" value="true" \/>  
<int name="enhanced_4g_lte_title_variant_int" value="1" \/>  
<boolean name="enhanced_4g_lte_on_by_default_bool" value="true" \/>  
<boolean name="hide_enhanced_4g_lte_bool" value="false" \/>  
<int name="lte_plus_threshold_bandwidth_khz_int" value="1" \/>  
<int name="nr_advanced_threshold_bandwidth_khz_int" value="1" \/>  
<boolean name="hide_lte_plus_data_icon_bool" value="true" \/>  
<boolean name="lte_enabled_bool" value="true" \/>  
<boolean name="show_data_connected_roaming_notification" value="true" \/>  
<boolean name="show_carrier_data_icon_pattern_string" value="true" \/>  
<boolean name="carrier_volte_available_bool" value="true" \/>  
<boolean name="carrier_default_wfc_ims_enabled_bool" value="true" \/>  
<boolean name="carrier_wfc_ims_available_bool" value="true" \/>  
<boolean name="carrier_vt_available_bool" value="true" \/>  
<boolean name="carrier_supports_ss_over_ut_bool" value="true" \/>  
'  
  
input_xml_texts_lines='  
<int-array name="carrier_nr_availabilities_int_array" num="2"\>  
<item value="1" \/>  
<item value="2" \/>  
<\/int-array>  
'  
phone_iccid_path="/data_mirror/data_de/null/0/com.android.phone/files"  
#######################################################################################################  
  
!!!What is not currently working is uninstalling.sh modules: carrierconfig-com.google.android.carrier-xxxx-xxxx.xml  
  
