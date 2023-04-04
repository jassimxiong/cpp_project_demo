![logo](./docs/logo.png)
<p align="center">
    <a href="#Language" alt="Language"><img src="https://img.shields.io/badge/language-cmake%20%7C%20shell%20%7C%20python%20%7C%20c%2Fc%2B%2B-blue" /></a>
    <a href="#arch" alt="arch"><img src="https://img.shields.io/badge/arch-arm%20%7C%20x86-important" /></a>
    <a href="#platform" alt="platform"><img src="https://img.shields.io/badge/platform-linux-blueviolet" /></a>
    <a href="#pm" alt="pm"><img src="https://img.shields.io/badge/pm-conan-brightgreen" /></a>
</p>

***

## 📒 版本历史

| 版本名 | 版本号 |  版本标签   |  版本描述  |    时间    |
| :----: | :----: | :---------: | :--------: | :--------: |
| 1.0.0  |   1    | `v1.0.0(1)` | 第一次提交 | 2023-02-20 |

## 📒 简要概述
该项目是一个用于c/c++项目的构建模板，不依赖任何IDE。
### 1、支持功能
+ [X] 第三方库管理
+ [X] 自定义安装包
+ [X] 一键测试（单元测试和其他自定义的测试用例）
+ [X] 生成测试报告
+ [X] 交叉编译
+ [X] 代码静态检查
+ [ ] 代码动态检查

### 2、目录结构
```bash
.
├── build # 构建目录
├── cmake # cmake自定义函数、宏等底层cmake代码
├── config # 配置文件
├── deps # 依赖包管理
├── docs # 文档、流程图等
├── output # 存放安装包、测试报告
└── src
    ├── main # 入口函数
    ├── unittest # 单元测试
    └── businesses # 业务代码
        ├── biz
        └── utility
```

### 3、注意事项
目前开发环境仅支持<font color = red>Linux</font>或者<font color = red>WSL</font>

## 📒 开始使用
### 1、编译环境搭建
+ 1、安装[conan][1]
```bash
sudo apt-get install python3 python3-pip
sudo pip install conan
conan --version
```

+ 2、安装工具集
```bash
sudo apt-get install git cmake cppcheck sshpass xsltproc
```

+ 3、安装编译器

如果是目标设备是x86架构
```bash
sudo apt-get install gcc g++
```

如果目标设备是arm架构，供应商会提供，也可按照网上的步骤自行安装

+ 4、配置项目

首先参考工程中<font color = red>cmake/ToolChian.cmake</font> 文件内容，添加您安装的编译器
接着修改<font color = red>cmake/ConfigProject.cmake</font>里的内容，也可以使用默认
最后修改 项目根目录中的<font color = red>CMakeLists.cmake</font>文件里的project_name


### 2、第三方库管理
打开顶层项目里的<font color = red>deps/conanfile.txt</font>文件，添加依赖的库，依赖的库可以去[conan中心][1]查找，编译代码，所有需要的conan包都会被安装到~/.conan/data目录下，在程序里链接CONAN_PKG::包名即可。

### 3、代码静态检查
目前项目中使用的静态分析工具是cppcheck，如果需要的话可以自行添加clang-tidy或者其他工具的支持。

### 4、编译
``` bash
./build.sh -b
```

执行命令后会编译输出所有的文件到build目录下。

### 5、生成打包需要的文件
``` bash
./build.sh -i
```

执行命令后会打包所需的文件按照标准的目录结构放到output目录下。


### 6、打包
``` bash
./build.sh -p
```

执行命令后会调用pack.py脚本生成安装包放到output目录下。


### 7、单元测试
如果目标设备使用的是ssh远程，修改test.sh里的主机名和密码，即可运行下面的命令。如果如果目标设备使用的是adb-server，可以自行更改test.sh里的代码。
``` bash
./build.sh -t
```
执行命令后会把需要运行的单元测试目标程序上传到目标设备去测试，测试结束后会把生成的xml文件pull到本地。

### 8、生成单元测试报告
执行<font color = red>./build.sh -t</font>后会使用xsltproc把测试时pull到本地的xml文件生成html文件，然后使用python的webbrowser在浏览器预览测试报告。如果需要，可以自行添加一个测试结果分析告警的功能。

### 9、自定义测试
可以自定义一个shell或者pyhton脚本，然后在<font color = red>cmake/Test.cmake</font>里添加即可。

***
👩‍💻 QQ交流群: <font color = green>634570694</font>

<p align="center">某某科技有限公司<p>

<p align="center">Copyright (C), 2010-2023, xxx Technology (BeiJing) Co., Ltd.<p>

[1]: https://conan.io/center
