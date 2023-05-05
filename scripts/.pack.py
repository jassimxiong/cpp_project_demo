"""
pip install rsa
"""
import os
import sys
import time
import json
import zipfile
import shutil
import hashlib
import rsa
import argparse

suffix = ".spk"
pkg_name = ""
version_name = ""
version_code = ""


def check_manifest(manifest_path):
    global pkg_name, version_name, version_code
    expected_fields = [
        "PkgName",
        "AppName",
        "VersionName",
        "VersionCode",
        "Arch",
        "Platform",
        "BuildDate",
        "GitHash",
        "Description",
    ]
    with open(manifest_path, "r") as f:
        manifest = json.load(f)
        missing_fields = set(expected_fields) - set(manifest.keys())
        if missing_fields:
            print("xx package.json 缺少以下必要字段：", ", ".join(missing_fields))
            return False
        else:
            pkg_name = manifest["PkgName"]
            version_name = manifest["VersionName"]
            version_code = manifest["VersionCode"]
            print("")
            for field in expected_fields:
                print(f"=> {field}: {manifest[field]}")
            print("")
            return True


def compress_folder(folder_path, zip_filename):
    with zipfile.ZipFile(zip_filename, "w", zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(folder_path):
            for file in files:
                file_path = os.path.join(root, file)
                zipf.write(file_path)
                # zipf.write(file_path, os.path.relpath(file_path, folder_path))
                print("📦 packing: %s" % file_path)


def move_to_target_folder(zip_filename, target_folder):
    if not os.path.exists(target_folder):
        os.mkdir(target_folder)
    os.rename(zip_filename, os.path.join(target_folder, zip_filename))


def sign_application(application_path, private_key_path, signature_path):
    """
    使用私钥对app进行签名
    :param application_path: app路径
    :param private_key_path: 私钥路径
    :param signature_path: 签名文件保存路径
    :return: None
    """
    # 读取数据
    with open(application_path, 'rb') as f:
        data = f.read()
    # 读取私钥
    with open(private_key_path, 'r') as f:
        private_key_data = f.read()
    # 转换为私钥对象
    private_key = rsa.PrivateKey.load_pkcs1(private_key_data.encode())
    # 计算数据哈希值
    data_hash = hashlib.sha256(data).digest()
    # 对哈希值进行签名
    signature = rsa.sign(data_hash, private_key, 'SHA-256')
    # 将签名保存到文件中
    with open(signature_path, 'wb') as f:
        f.write(signature)


def pack(folder_path, private_key_path):
    # 检查 manifest.json
    if check_manifest(folder_path + "/manifest.json") == False:
        sys.exit()
    if not os.path.exists(private_key_path):
        print(f"xx {private_key_path}文件不存在")
        sys.exit()
    # 重命名要压缩的文件夹目录名
    application = "application"
    zip_application = application + ".all"
    shutil.copytree(folder_path, application)
    # 压缩app相关文件
    compress_folder(application, zip_application)
    shutil.rmtree(application)
    # 移动到pkg_name目录下
    target_folder = pkg_name
    move_to_target_folder(zip_application, target_folder)
    # 签名
    signature_path = pkg_name + "/signature.sig"
    zip_application_path = pkg_name + "/" + zip_application
    sign_application(zip_application_path, private_key_path, signature_path)
    # 打包
    str_time = time.strftime('%Y%m%d%H%M%S', time.localtime(time.time()))
    output_name = pkg_name + "_v" + version_name + \
        "_" + str(version_code) + "_" + str_time + suffix
    compress_folder(pkg_name, output_name)
    shutil.rmtree(pkg_name)


def generate_key_pair(private_key_path, public_key_path, key_size=2048):
    """
    生成RSA公私钥对, 保存到指定路径下的文件中
    :param private_key_path: 私钥保存路径
    :param public_key_path: 公钥保存路径
    :param key_size: 密钥长度, 默认为2048位
    :return: None
    """
    # 生成RSA密钥对
    (pubkey, privkey) = rsa.newkeys(key_size)
    # 将私钥保存到文件中
    with open(private_key_path, 'w') as f:
        f.write(privkey.save_pkcs1().decode())
    # 将公钥保存到文件中
    with open(public_key_path, 'w') as f:
        f.write(pubkey.save_pkcs1().decode())


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pack", metavar="directory", help="打包指定文件")
    parser.add_argument("-k", "--key", metavar="key_file", help="RSA私钥")
    parser.add_argument("-g", "--generate_key",
                        action="store_true", help="生成RSA密钥对")
    args = parser.parse_args()
    if args.generate_key:
        print("** 生成密钥对")
        generate_key_pair("private.key", "public.key", 2048)
    elif args.pack and args.key:
        print("** 打包指定文件: ", args.pack)
        print("** 私钥路径: ", args.key)
        pack(args.pack, args.key)
    elif args.pack or args.key:
        print("** 参数不正确，-p和-k需要同时指定")
    else:
        parser.print_help()
    print("")
    print(" 注意：请按照规范提供正确的包描述文件：")
    print("(可参考https://github.com/xxx)")
