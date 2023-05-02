"""
pip install rsa
"""
import rsa
import hashlib
import argparse


def verify_signature(data_path, signature_path, public_key_path):
    """
    使用公钥验证签名
    :param data_path: 数据路径
    :param signature_path: 签名文件路径
    :param public_key_path: 公钥路径
    :return: 签名验证结果, True表示验证通过, False表示验证失败
    """
    # 读取数据
    with open(data_path, 'rb') as f:
        data = f.read()
    # 读取签名文件数据
    with open(signature_path, 'rb') as f:
        signature = f.read()
    # 读取公钥
    with open(public_key_path, 'r') as f:
        public_key_data = f.read()
    # 转换为公钥对象
    public_key = rsa.PublicKey.load_pkcs1(public_key_data.encode())
    # 计算数据哈希值
    data_hash = hashlib.sha256(data).digest()
    # 验证签名
    try:
        rsa.verify(data_hash, signature, public_key)
        return True
    except:
        return False


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--package", metavar="package",
                        help="application.all")
    parser.add_argument("-s", "--signature",
                        metavar="signature_file", help="签名文件")
    parser.add_argument("-k", "--key", metavar="key_file", help="RSA公钥")
    args = parser.parse_args()
    if args.package and args.signature and args.key:
        print("** app: ", args.package)
        print("** 签名: ", args.signature)
        print("** 公钥: ", args.key)
        # 使用公钥验证签名
        if verify_signature(args.package, args.signature, args.key):
            print("签名验证通过")
        else:
            print("签名验证失败")
    elif args.package or args.signature or args.key:
        print("** 参数不正确，-p、-s和-k需要同时指定")
    else:
        parser.print_help()
