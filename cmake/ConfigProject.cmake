# APP_NAME: 对外的名称，可以和进程名一致
# PKG_NAME: 包名, 用公司域名倒过来 + app_name保证唯一性
# VERSION_NAME： 版本名, 暴露给用户看的版本名，X.Y.Z
# 1、X为主版本，不需要向下兼；
# 2、Y为次版本，向下兼容，属于增量升级, 例如增加新功能，新接口；
# 3、Z为修订版本, 向下兼容, 比如修复某个函数里的某个逻辑;
# VERSION_CODE: 版本号，公司内部用于升级时判断新旧版本，是一个递增非负数，一般情况版本号递增时版本名也一起递增
# DESCRIPTION： 升级包描述
# STARTUP_SHELL_NAME: 开机自启动脚本
# DAEMONS: 守护进程，保活
# APP_ROOT_DIR: 安装到目标设备的什么路径
# BUILD_DATE: 编译代码时的时间
# ARCH: 处理器架构
# PLATFORM： 系统平台

set(APP_NAME ${PROJECT_NAME})
set(PKG_NAME "com.company.${APP_NAME}")
set(VERSION_NAME "3.0.1")
set(VERSION_CODE "101")
set(DESCRIPTION "修复xxxbug, 优化性能")
set(STARTUP_SHELL_NAME "S99_${APP_NAME}")
set(DAEMONS "demons_${APP_NAME}")
set(APP_ROOT_DIR "/home/app")
set(ARCH "x86")
set(PLATFORM "linux")
string(TIMESTAMP BUILD_DATE "%Y-%m-%d %H:%M:%S")

# 传递给c++代码
set(Definitions
    APP_NAME="${APP_NAME}"
    PKG_NAME="${PKG_NAME}"
    VERSION_NAME="${VERSION_NAME}"
    VERSION_CODE="${VERSION_CODE}"
    ARCH="${ARCH}"
    PLATFORM="${PLATFORM}"
)