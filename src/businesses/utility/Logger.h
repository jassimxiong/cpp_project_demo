#ifndef __LOGGER_H__
#define __LOGGER_H__

#include "spdlog/async.h"
#include "spdlog/sinks/basic_file_sink.h"
#include "spdlog/sinks/rotating_file_sink.h"
#include "spdlog/sinks/stdout_color_sinks.h"
#include "spdlog/spdlog.h"
#include "utility/Singleton.h"

#include <memory>

#define LogE(...) Logger::GetInstance().LogError(__VA_ARGS__)
#define LogW(...) Logger::GetInstance().LogWarn(__VA_ARGS__)
#define LogI(...) Logger::GetInstance().LogInfo(__VA_ARGS__)
#define LogD(...) Logger::GetInstance().LogDebug(__VA_ARGS__)
#define LogC(...) Logger::GetInstance().LogCritical(__VA_ARGS__)

class Logger : public Singleton<Logger> {
  private:
    std::shared_ptr<spdlog::logger> logger_;

  public:
    static Logger &GetInstance() {
        static Logger instance;
        return instance;
    }

    bool Init(const std::string &topic, const std::string &log_file_name, long log_file_size,
              int rotation) {
        try {
            auto stdout_sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
            auto rotating_sink = std::make_shared<spdlog::sinks::rotating_file_sink_mt>(
                log_file_name, log_file_size, rotation);
            std::vector<spdlog::sink_ptr> sinks{ stdout_sink, rotating_sink };
            logger_ = std::make_shared<spdlog::logger>(topic, sinks.begin(), sinks.end());
            logger_->set_pattern("[%Y-%m-%d %H:%M:%S.%f] [%^%L%$] [%n](tid %t) %v");
            logger_->set_level(spdlog::level::debug);
            logger_->flush_on(spdlog::level::err);
            return true;
        } catch (...) {
            return false;
        }
    }
    template <typename... Args>
    inline void LogError(const char *fmt, Args... args) {
        logger_->error(fmt, args...);
    }

    template <typename... Args>
    inline void LogWarn(const char *fmt, Args... args) {
        logger_->warn(fmt, args...);
    }

    template <typename... Args>
    inline void LogInfo(const char *fmt, Args... args) {
        logger_->info(fmt, args...);
    }

    template <typename... Args>
    inline void LogDebug(const char *fmt, Args... args) {
        logger_->debug(fmt, args...);
    }

    template <typename... Args>
    inline void LogCritical(const char *fmt, Args... args) {
        logger_->critical(fmt, args...);
    }
};

#endif // __LOGGER_H__