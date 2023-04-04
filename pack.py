import os, time, json, sys, zipfile

suffix = ".spk"
version_code = 0
version_name = ""
folder_name = ""
folder_path = ""
output_name = ""
current_path = ""

# 拼接路径
def SplitJointPath():
    global folder_name, folder_path, current_path
    if len(sys.argv) == 2:
        folder_name = sys.argv[1]
        current_path = os.getcwd()
        folder_path = current_path + "/" + folder_name
        print("")
        print("++ sources:%s" % (folder_path))
    else:
        print("++ 用法: python3 pack.py com.company.app_name(包名)")
        return 1

def LoadPkgInfoFromManifest():
    global folder_path, version_code, version_name
    manifest_path = folder_path + "/manifest.json"
    if os.path.exists(manifest_path):
        try:
            with open(manifest_path, 'r') as file:
                data = json.load(file)
                if("PkgName" in data):
                	print("++ 包名: %s" % (data['PkgName']))
                else:
                	print("xx 包描述文件里没有PkgName")
                	return 0
                if("AppName" in data):
                	print("++ 应用名: %s" % (data['AppName']))
                else:
                	print("xx 包描述文件里没有AppName")
                	return 0
                if("VersionName" in data):
                    version_name = data['VersionName']
                    print("++ 版本名: %s" % version_name)
                else:
                	print("xx 包描述文件里没有VersionName")
                	return 0
                if("VersionCode" in data):
                	version_code = data['VersionCode']
                	print("++ 版本号: %s" % (version_code))
                else:
                	print("xx 包描述文件里没有VersionCode")
                	return 0
                if("Arch" in data):
                	print("++ 处理器: %s" % (data['Arch']))
                else:
                	print("xx 包描述文件里没有Arch")
                	return 0
                if("Platform" in data):
                	print("++ 运行平台: %s" % (data['Platform']))
                else:
                	print("xx 包描述文件里没有Platform")
                	return 0
                if("BuildDate" in data):
                	print("++ 编译时间: %s" % (data['BuildDate']))
                else:
                	print("xx 包描述文件里没有BuildDate")
                	return 0
                if("Description" in data):
                	print("++ 升级描述: %s" % (data['Description']))
                else:
                	print("xx 包描述文件里没有Description")
                	return 0
                return 1
        except:
            print("xx 读manifest.json失败")
    else:
        print("xx 包描述文件manifest.json不存在")

def Pack():
    global output_name, version_code, version_name, folder_name
    str_time = time.strftime('%Y%m%d%H%M', time.localtime(time.time()))
    output_name = folder_name + "_v" + version_name + "_" + str(version_code) + "_" + str_time + suffix
    print("")
    with zipfile.ZipFile(output_name, "w") as zipf:
        for root, dirs, files in os.walk(folder_name):
            for file in files:
                file_path = os.path.join(root, file)
                ret = zipf.write(file_path)
                print("📦 packing: %s" % file_path)
    file_name = current_path + "/" + output_name
    print(" package: %s" % file_name)

def Notice():
    print("")
    print(" 请注意打包文件的目录结构规范：")
    print("(可参考https://github.com/xxx)")

if __name__ == '__main__':
    ret = SplitJointPath()
    if ret == 1:
        sys.exit()
    ret = LoadPkgInfoFromManifest()
    if ret == 1:
        Pack()
    Notice()
    exit