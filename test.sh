#!/bin/bash

project_dir=$(pwd)
exe="test_demo"
test_report=report.xml
device_ip="192.168.1.111"
device_username=xxx
device_passwd="123456"
run_path="/home/app"
output="$project_dir"/"output"
output_html="$output"/report.html

# 生成测试报告
sshpass -p"$device_passwd" scp "$project_dir"/build/"$exe" "$device_username"@"$device_ip":~"$run_path" || exit 1
sshpass -p"$device_passwd" ssh "cd $run_path && nohup ./$exe -r xml -o $test_report" || exit 1
mkdir -p "$output"
sshpass -p"$device_passwd" scp "$device_username"@"$device_ip":~"$run_path"/"$test_report" "$output" || exit 1
xsltproc "$project_dir"/report_template.xslt "$output"/"$test_report" > "$output"/report.html || exit

# 展示测试报告
/bin/python3 << !EOF!
import os, webbrowser, sys
try:
	from urllib import pathname2url
except:
	from urllib.request import pathname2url
def main():
    webbrowser.open("file://" + pathname2url(os.path.abspath("$output_html")))
main()
!EOF!