// Copyright(c) 2015-present, Gabi Melman & spdlog contributors.
// Distributed under the MIT License (http://opensource.org/licenses/MIT)

#pragma once

#include <spdlog/details/fmt_helper.h>
#include <spdlog/details/null_mutex.h>
#include <spdlog/details/os.h>
#include <spdlog/sinks/base_sink.h>
#include <spdlog/details/synchronous_factory.h>

#include <chrono>
#include <mutex>
#include <string>
#include <thread>

namespace spdlog {
namespace sinks {

template<typename Mutex>
class ios_sink final : public base_sink<Mutex>
{
public:
    explicit ios_sink(bool use_raw_msg = false)
        : use_raw_msg_(use_raw_msg)
    {}

protected:
    void sink_it_(const details::log_msg &msg) override
    {
        memory_buf_t formatted;
        if (use_raw_msg_)
        {
            details::fmt_helper::append_string_view(msg.payload, formatted);
        }
        else
        {
            base_sink<Mutex>::formatter_->format(msg, formatted);
        }
        formatted.push_back('\0');
        const char *msg_output = formatted.data();
        NSLog(@"%s",msg_output);
    }

    void flush_() override {}

private:
    bool use_raw_msg_;
};

using ios_sink_mt = ios_sink<std::mutex>;
using ios_sink_st = ios_sink<details::null_mutex>;
} // namespace sinks

// Create and register ios syslog logger

template<typename Factory = spdlog::synchronous_factory>
inline std::shared_ptr<logger> ios_logger_mt(const std::string &logger_name, const std::string &tag = "spdlog")
{
    return Factory::template create<sinks::ios_sink_mt>(logger_name, tag);
}

template<typename Factory = spdlog::synchronous_factory>
inline std::shared_ptr<logger> ios_logger_st(const std::string &logger_name, const std::string &tag = "spdlog")
{
    return Factory::template create<sinks::ios_sink_st>(logger_name, tag);
}

} // namespace spdlog
