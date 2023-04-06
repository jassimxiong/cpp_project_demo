#!/bin/bash
build_dir=$(pwd)
exe="test_demo"
test_report=report.xml
device_ip="192.168.1.100"
device_username=root
device_passwd="123456"
run_path="/home"
output="$build_dir/../output"
output_html="$output"/report.html

# 生成测试报告
sshpass -p$device_passwd scp "$build_dir/$exe" $device_username@$device_ip:$run_path || exit 1
sshpass -p$device_passwd ssh "$device_username@$device_ip" "cd $run_path && nohup ./$exe -r xml -o $test_report" || exit 1
mkdir -p "$output"
sshpass -p"$device_passwd" scp "$device_username"@"$device_ip":"$run_path"/"$test_report" "$output" || exit 1
xsltproc "$build_dir"/../report_template.xslt "$output"/"$test_report" > "$output"/report.html || exit
sshpass -p$device_passwd ssh "$device_username@$device_ip" "rm $run_path/$test_report $run_path/$exe"

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