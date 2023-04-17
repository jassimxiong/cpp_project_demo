#!/bin/bash
ERROR="\e[31;1m"      
INFO="\e[32;1m"
WARN="\e[33;1m"
NOTE="\e[33;1m\033[5m"
RESET="\033[0m"

output_dir="output"
tag="${INFO}[pack]${RESET}"
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

print info 开始打包...
cd "$project_dir"
mkdir -p "$project_dir/$output_dir"
for file in $(ls "$project_dir/$output_dir")
do
    if [[ -d "$project_dir/$output_dir/$file" ]] && [[ "$project_dir/$output_dir/$file" =~ "com." ]]
    then
        cd "$project_dir/$output_dir" && python3 "$project_dir"/scripts/.pack.py "$file"  && rm "$file" -rf && cd - || exit 0
    fi
done 
print info 打包结束...