#include "Test.h"
#include "utility/Logger.h"

#include <chrono>
#include <memory>
#include <thread>

#define BLUE "\033[;34m" // 蓝色
#define GREE "\033[;32m" // 绿色
#define YELL "\033[;33m" // 黄色
#define PURP "\033[;35m" // 紫色
#define END "\033[0m\n"  // 结束

void LoggerInit() {
    std::string topic = APP_NAME;
    std::string log_file_name = APP_NAME ".log";
    long log_file_size = 1048576 * 3; // 3MB
    int rotation = 3;                 // 日志文件满3个时开始滚动日志
    while (!Logger::GetInstance().Init(topic, log_file_name, log_file_size, rotation)) {
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
}

void Banner() {
    LogI(BLUE "\n                                                     " END BLUE
              "                        __                             " END BLUE
              "                   ____/ /__  ____ ___  ____           " END GREE
              "                  / __  / _ \\/ __ `__ \\/ __ \\          " END YELL
              "                 / /_/ /  __/ / / / / / /_/ /          " END YELL
              "                 \\__,_/\\___/_/ /_/ /_/\\____/           " END PURP
              "     ╭─────────────────────────────────────────────────" END PURP
              "     │ 应用名称:{}                                       " END PURP
              "     │ 应用包名:{}                                       " END PURP
              "     │ 应用版本:{}({})                                   " END PURP
              "     │ 运行架构:{}                                       " END PURP
              "     │ 运行平台:{}                                       " END PURP
              "     │ GIT哈希:{}                                       " END PURP
              "     │ 构建日期:{}                                       " END PURP
              "     ╰───────────────────────────────────────────────── " END BLUE
              "     Copyright (C), 2023 xxx,                           " END,
         APP_NAME, PKG_NAME, VERSION_NAME, VERSION_CODE, ARCH, PLATFORM, GIT_HASH, BUILD_DATE);
}

int main() {
    LoggerInit();
    Banner();
    auto test = std::make_shared<Test>();
    std::thread t([&]() {
        while (true) {
            test->SayHello();
            LogI("{}, {}", APP_NAME, PKG_NAME);
            LogD("{}, {}", APP_NAME, PKG_NAME);
            LogW("{}, {}", APP_NAME, PKG_NAME);
            LogE("{}, {}", APP_NAME, PKG_NAME);
            LogC("{}, {}", APP_NAME, PKG_NAME);
            std::this_thread::sleep_for(std::chrono::seconds(1));
        }
    });
    t.join();
    return 0;
}