# encoding=utf-8

import io, re, os, sys, fileinput

# 设置环境变量 PYTHONUNBUFFERED 为 1
os.environ['PYTHONUNBUFFERED'] = '1'

# 使用列表推导式将多行字符串转换为行列表：
xml_text = r"""
<boolean name="vonr_enabled_bool" value="true" />
<boolean name="vonr_setting_visibility_bool" value="true" />
<boolean name="vendor_hide_volte_settng_ui" value="false" />
<boolean name="editable_enhanced_4g_lte_bool" value="true" />
<boolean name="editable_wfc_mode_bool" value="true" />
<boolean name="enhanced_4g_lte_title_variant_bool" value="true" />
<boolean name="enhanced_4g_lte_on_by_default_bool" value="true" />
<int name="wfc_spn_format_idx_int" value="1" />
<int name="enhanced_4g_lte_title_variant_int" value="1" />
<int name="lte_plus_threshold_bandwidth_khz_int" value="1" />
<int name="nr_advanced_threshold_bandwidth_khz_int" value="1" />
<boolean name="hide_enhanced_4g_lte_bool" value="false" />
<boolean name="hide_lte_plus_data_icon_bool" value="false" />
<boolean name="hide_carrier_network_settings_bool" value="false" />
<boolean name="hide_preferred_network_type_bool" value="false" />
<boolean name="lte_enabled_bool" value="true" />
<boolean name="show_data_connected_roaming_notification" value="true" />
<boolean name="show_carrier_data_icon_pattern_string" value="true" />
<boolean name="carrier_volte_available_bool" value="true" />
<boolean name="carrier_default_wfc_ims_enabled_bool" value="true" />
<boolean name="carrier_wfc_ims_available_bool" value="true" />
<boolean name="carrier_vt_available_bool" value="true" />
<boolean name="carrier_supports_ss_over_ut_bool" value="true" />
"""

pattern_input = re.compile(r'name="([^"]+)"')
matches_input = pattern_input.findall(xml_text)
# 正则表达式匹配name="xxx"格式 , for in 循环结果赋值全局
processed_chars_input = []
for matches_str_input in matches_input:
    # print(matches_str)
    processed_chars_input.append(matches_str_input)
#join 字符串换行符合保留
processed_text_input = '\n'.join(processed_chars_input)
# print(f"xml_text_input Name_1：\n\n{processed_text_input}\n\n")


# 正则表达式匹配name="xxx"格式
file_path = 'C:/Users/OTTF/Desktop/Vs Code/test.sh'

with open(file_path, 'r') as file:
    content = file.read()
    # content = content.replace('\\n', '\n')
pattern_output = re.compile(r'name="([^"]+)"')
matches_output = pattern_output.findall(content)
# 正则表达式匹配name="xxx"格式 , for in 循环结果赋值全局
processed_chars_output = []
for matches_str_output in matches_output:
    # print(matches_str_output)
    processed_chars_output.append(matches_str_output)
#join 字符串换行符合保留
processed_text_output = '\n'.join(processed_chars_output)
# print(f"xml_text_output Name_2：\n\n{processed_text_output}\n\n")


# xml_text_input Name_1 : 总行数统计
from collections import Counter

def count_lines_input():
    # 使用 Counter 类来统计换行符的数量
    line_counts_input = Counter("\n" in line for line in processed_text_input.splitlines(keepends=True))
    # 返回总的行数
    return sum(line_counts_input.values())

# 统计文本中的行数
line_count_input = count_lines_input()
print(f"\nxml_text_input Name_1 : 总行数统计 = {line_count_input} 行\n")


# xml_text_output Name_2 : 总行数统计
from collections import Counter

def count_lines_output():
    # 使用 Counter 类来统计换行符的数量
    line_counts_output = Counter("\n" in line for line in processed_text_output.splitlines(keepends=True))
    # 返回总的行数
    return sum(line_counts_output.values())

# xml_text_output Name_2 : 总行数统计
line_count_output = count_lines_output()
print(f"\nxml_text_output Name_2 : 总行数统计 = {line_count_output} 行\n")


# 内容行name="xxx"名称对比筛选唯一值, 只保留唯一值的行.

processed_text_only =  processed_chars_input + processed_chars_output
processed_text_only_join = '\n'.join(processed_text_only)
# print(f"processed_text_only = processed_text_output + processed_text_input {processed_text_only_join}")

lines = [line.rstrip() for line in processed_text_only_join.splitlines()]

# 使用set去除重复值，然后转换回list
unique_lines = list({line for line in lines if lines.count(line) == 1})

# 输出结果，并且在每行末尾添加换行符
# print('\n'.join(unique_lines))
unique_lines_only = '\n'.join(unique_lines)
# 不换行
# print(unique_lines)
# 换行
print(f"唯一值：\n{unique_lines_only}")


# unique_lines_only_counts Name_3 : 总行数统计

def unique_lines_only_counts():
    # def count_lines(text):
    lines = unique_lines_only.splitlines()
    non_empty_lines = [line for line in lines if line.strip()]  # 使用strip()去除空白字符
    # total_lines = len(lines)
    non_empty_lines_count = len(non_empty_lines)
    return non_empty_lines_count
non_empty_lines_count = unique_lines_only_counts()
print(f"非空白行数:  {non_empty_lines_count} ")

# Name= "xxx" 匹配所在行 unique_lines

pattern = '|'.join(unique_lines)  # 创建正则表达式模式

input_lines_file = []

for line_up in xml_text.split("\n"):
    if re.search(pattern, line_up):  # 检查是否匹配正则表达式
        # print(line_up)  # 打印匹配行
        input_lines_file.append(line_up)

output_lines_file = '\n'.join(input_lines_file)
if non_empty_lines_count > 0 :
    print(f"xml写入单行:\n{output_lines_file}")
else:
    print(f"xml写入单行: 0")
# 打开文件
with open(file_path, 'r') as file:
    lines = file.readlines()  # 读取所有行
    if line_count_output < line_count_input:
        lines.insert(1, output_lines_file + '\n')  # 在第二行后插入新行
    else:
        # lines.insert(1, output_lines_file )  # 在第二行后插入新行
        print(f"行数: 0")
# 写入文件，覆盖原有内容
with open(file_path, 'w') as file:
    file.writelines(lines)


# 多行Name="xxx"匹配
xml_text_lines = r"""
<int-array name="carrier_nr_availabilities_int_array" num="2">
<item value="1" />
<item value="2" />
</int-array>
"""

pattern_input_lines = re.compile(r'name="([^"]+)"')
matches_input_lines = pattern_input_lines.findall(xml_text_lines)
# 正则表达式匹配name="xxx"格式 , for in 循环结果赋值全局
processed_chars_input_lines = []
for matches_str_input_lines in matches_input_lines:
    # print(matches_str_lines)
    processed_chars_input_lines.append(matches_str_input_lines)
#join 字符串换行符合保留
processed_text_input_lines = '\n'.join(processed_chars_input_lines)
print(f"\nxml_text_input Name_5：\n\n{processed_text_input_lines}\n")

# 正则表达式匹配name="xxx"格式
with open(file_path, 'r') as file:
    content = file.read()
    # content = content.replace('\\n', '\n')
pattern_output_lines = re.compile(r'name="([^"]+)"')
matches_output_lines = pattern_output_lines.findall(content)
# 正则表达式匹配name="xxx"格式 , for in 循环结果赋值全局
processed_chars_output_lines = []
for matches_str_output_lines in matches_output_lines:
    # print(matches_str_output_lines)
    processed_chars_output_lines.append(matches_str_output_lines)
#join 字符串换行符合保留
processed_text_output_lines = '\n'.join(processed_chars_output_lines)

processed_text_only_lines =  processed_chars_input_lines + processed_chars_output_lines
processed_text_only_join_lines = '\n'.join(processed_text_only_lines)
# print(f"processed_text_only_lines = processed_text_output_lines + processed_text_input_lines {processed_text_only_join_lines}")

lines = [line.rstrip() for line in processed_text_only_join_lines.splitlines()]

# 使用set去除重复值，然后转换回list
unique_lines_xml = list({line for line in lines if lines.count(line) == 1})

# 输出结果，并且在每行末尾添加换行符
# print('\n'.join(unique_lines))
unique_lines_only_xml = '\n'.join(unique_lines_xml)
# 不换行
# print(unique_lines)
# 换行
print(f"唯一值多行：\n{unique_lines_only_xml}")

# unique_lines_only_counts_xml Name_3 : 总行数统计

def unique_lines_only_counts_xml():
    # def count_lines(text):
    lines = unique_lines_only_xml.splitlines()
    non_empty_lines_xml = [line for line in lines if line.strip()]  # 使用strip()去除空白字符
    # total_lines = len(lines)
    non_empty_lines_count_xml = len(non_empty_lines_xml)
    return non_empty_lines_count_xml

non_empty_lines_count_xml = unique_lines_only_counts_xml()
print(f"非空白行数:  {non_empty_lines_count_xml} ") #name_xml数量

# Name= "xxx" 匹配所在行 unique_lines_xml

pattern = '|'.join(unique_lines_xml)  # 创建正则表达式模式

input_lines_file_xml = []

for line_up in xml_text_lines.split("\n"):
    if re.search(pattern, line_up):  # 检查是否匹配正则表达式
        # print(line_up)  # 打印匹配行
        input_lines_file_xml.append(line_up)

output_lines_file_xml = '\n'.join(input_lines_file_xml)
if non_empty_lines_count_xml > line_count_output :
    print(f"xml写入多行:\n{output_lines_file_xml}")
else:
    print(f"xml写入多行: 0")
# 打开文件
# 打印xml剩下行数
# 将字符串按行分割，并移除第一行
lines = xml_text_lines.splitlines()
lines.pop(1)  # 删除第一行

# 将剩余的行重新合并为一个字符串
text_without_first_line = '\n'.join(lines)

# print(f"多行输出：\n{text_without_first_line}")

with open(file_path, 'r') as file:
    lines = file.readlines()  # 读取所有行
    if  output_lines_file_xml and non_empty_lines_count_xml > line_count_output :
        lines.insert(1, output_lines_file_xml + text_without_first_line + '\n')  # 在第二行后插入新行
    else:
        # lines.insert(1, output_lines_file )  # 在第二行后插入新行
        print(f"多行数: 0")
# 写入文件，覆盖原有内容
with open(file_path, 'w') as file:
    file.writelines(lines)
#
