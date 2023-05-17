#include "utility/Logger.h"

#include <catch2/catch.hpp>

#include <unistd.h>

TEST_CASE("测试Logger", "[Logger]") {
    const std::string topic = "test";
    const std::string log_file_name = "test.log";
    long log_file_size = 1048576; // 1MB
    int rotation = 3;
    REQUIRE(Logger::GetInstance().Init(topic, log_file_name, log_file_size, rotation));
    SECTION("错误日志") { REQUIRE_NOTHROW(Logger::GetInstance().LogError("test error")); }
    SECTION("警告日志") { REQUIRE_NOTHROW(Logger::GetInstance().LogWarn("test warning")); }
    SECTION("正常输出的日志") { REQUIRE_NOTHROW(Logger::GetInstance().LogInfo("test info")); }
    SECTION("调试日志") { REQUIRE_NOTHROW(Logger::GetInstance().LogDebug("test debug")); }
    SECTION("紧急情况日志") { REQUIRE_NOTHROW(Logger::GetInstance().LogCritical("test critical")); }
    std::string cmd("rm ");
    cmd.append(log_file_name);
    system(cmd.c_str());
}