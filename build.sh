#!/bin/bash

ERROR="\e[31;1m"      
INFO="\e[32;1m"
WARN="\e[33;1m"
NOTE="\e[33;1m\033[5m"
RESET="\033[0m"

output_dir="output"
# 参数数量
arg_num=$#
# 参数一的内容
arg=$1
tag="${INFO}[build]${RESET}"
project_dir=$(pwd)
echo "$project_dir"
print() {
    case "$1" in
    "error")
        echo -e "$tag ${ERROR}$2${RESET}"
        ;;
    "info")
        echo -e "$tag $2"
        ;;
    "warn")
        echo -e "$tag ${WARN}$2${RESET}"
        ;;
    "note")
        echo -e "$tag ${NOTE}$2${RESET}"
        ;;
    *)
        echo -e "$tag $2"
    ;;
    esac
}

build() {
    print info 开始编译...
    if [[ ! -d "$project_dir/build" ]] || [[ -z "$(ls -A "$project_dir"/build)" ]]
    then
        cmake -B "$project_dir"/build -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE="$project_dir"/cmake/ToolChain.cmake #-G Ninja
    fi
	cmake --build "$project_dir"/build --parallel
    print info 编译结束...
}

install() {
    print info 开始安装...
	cd "$project_dir"/build || exit 1
    make install
    cd - || exit 1
    print info 安装结束...
}

pack() {
    print info 开始打包...
    cd "$project_dir" || exit 1
    mkdir -p "$project_dir"/"$output_dir"
    for file in $(ls "$1")
    do
        if [[ -d "$1/$file" ]] && [[ "$file" =~ "com." ]]
        then
            cd "$project_dir"/"$output_dir" && python3 "$project_dir"/pack.py "$file"  && rm "$file" -rf && cd - || exit 0
        fi
    done 
    print info 打包结束...
}

test() {
    print info 开始测试...
    ctest --test-dir "$project_dir"/build -C Release #-VV --rerun-failed --output-on-failure
    print info 测试结束...
}

clean() {
    print info 开始clean...
	rm "$project_dir"/build -rf
	rm "$project_dir"/output -rf
    print info clean结束...
}

help() {
    print info 用法:
    print warn  "$0 -b  编译代码"
    print warn  "$0 -i  安装打包的资源文件"
    print warn  "$0 -p  打包成安装包"
    print warn  "$0 -t  一键测试"
    print warn  "$0 -c  清除编译缓存"
    print warn  "$0 -h  帮助"
}

if [[ ${arg_num} -ne 1 ]]
then
    help
    exit 1
fi
case "${arg}" in
    "-b")
        build
        ;;
    "-i")
        build
        install
        ;;
    "-p")
        build
        install
        pack "$output_dir"
        ;;
    "-t")
        build
        install
        pack "$output_dir"
        test
        ;;
    "-c")
        clean
        ;;
    "-h")
        help
        ;;
    *)
        help
        ;;
    esac
exit 0