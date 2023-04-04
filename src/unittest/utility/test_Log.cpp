#include "utility/Logger.h"
#include <catch2/catch.hpp>

TEST_CASE("测试日志") {
    const std::string topic = "test";
    const std::string log_file_name = "test.log";
    long log_file_size = 1048576; // 1MB
    int rotation = 3;
    REQUIRE(Logger::GetInstance().Init(topic, log_file_name, log_file_size, rotation));
    SECTION("错误日志") { Logger::GetInstance().LogError("test error"); }
    SECTION("警告日志") { Logger::GetInstance().LogWarn("test warning"); }
    SECTION("正常输出的日志") { Logger::GetInstance().LogInfo("test info"); }
    SECTION("调试日志") { Logger::GetInstance().LogDebug("test debug"); }
    SECTION("紧急情况日志") { Logger::GetInstance().LogCritical("test critical"); }
}