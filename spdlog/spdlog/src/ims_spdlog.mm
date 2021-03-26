//
// Created by yuhao on 3/18/21.
//
#import <Foundation/Foundation.h>
#include <spdlog/ims_spdlog.h>
#include <spdlog/spdlog.h>
#include <spdlog/sinks/rotating_file_sink.h>
#include <spdlog/sinks/ios_sink.h>
#define TAG "IMSSpdlog"

#define LOG_BUF_SIZE 1024
#define LOG_WRITE_AV_DURATION 3

static bool isInit = false;
static std::shared_ptr<spdlog::logger> audio_logger = nullptr;
static std::shared_ptr<spdlog::logger> video_logger = nullptr;
static long long audio_logger_last_time = 0;
static long long video_logger_last_time = 0;


NSString *log_file_output_path() {
    NSString *pathString =
        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    if (pathString == nil) {
      pathString = @"";
    } else {
      pathString = [NSString stringWithFormat:@"%@/ims", pathString];
      NSFileManager *fileManager = [NSFileManager defaultManager];
      if (![fileManager fileExistsAtPath:pathString]) {
        if ([fileManager createDirectoryAtPath:pathString withIntermediateDirectories:YES attributes:nil error:nil] == NO) {
          pathString = @"";
        }
      }
    }
    return pathString;
}

void init_spdlog() {
    if (isInit) {
        return;
    }
    NSString *pathString = log_file_output_path();
    std::string path([pathString UTF8String]);
    spdlog::set_level(spdlog::level::debug);
    std::string normal_file = path + "/ims_normal_rotating.txt";
    auto file_sink = std::make_shared<spdlog::sinks::rotating_file_sink_mt>(normal_file, 1024 * 1024 * 5, 3);
    file_sink->set_pattern("%Y-%m-%d %H:%M:%S.%e %P-%t %L/%v");

    std::vector<spdlog::sink_ptr> sinks;
    sinks.push_back(file_sink);

    auto ios_sink = std::make_shared<spdlog::sinks::ios_sink_mt>(true);
    ios_sink->set_pattern("%v");
    sinks.push_back(ios_sink);


    auto combined_logger = std::make_shared<spdlog::logger>( "multi_sink", begin( sinks ), end( sinks ));
    spdlog::set_default_logger(combined_logger);

    std::chrono::seconds s(3);
    spdlog::flush_every(s);

    spdlog_reset_av_print_last_time();
    std::string audio_file = path + "/ims_audio_rotating.txt";
    audio_logger = spdlog::rotating_logger_mt("audio_logger", audio_file, 1024 * 1024 * 5, 3);
    audio_logger->set_pattern("%Y-%m-%d %H:%M:%S.%e %P-%t %L/%v");

    std::string video_file = path + "/ims_video_rotating.txt";
    video_logger = spdlog::rotating_logger_mt("video_logger", video_file, 1024 * 1024 * 5, 3);
    audio_logger->set_pattern("%Y-%m-%d %H:%M:%S.%e %P-%t %L/%v");

    isInit = true;
    SPDLOGD(TAG, @"init_spdlog");
    SPDLOGW(TAG, @"init_spdlog");
    SPDLOGE(TAG, @"init_spdlog");
    SPDLOGI(TAG, @"init_spdlog path:%s", path.c_str());
}

void deinit_spdlog() {
    if (isInit) {
        SPDLOGI(TAG, @"deinit_spdlog");
        spdlog::drop_all();
    }
}

void spdlog_normal_print(level_enum l, const char* tag, NSString* fmt, ...) {
    if (isInit) {
        va_list args;
        va_start(args, fmt);
        NSString *log = [[NSString alloc] initWithFormat:fmt arguments:args];
        va_end(args);
        if (l == info) {
            spdlog::info("{}: {}", tag, [log UTF8String]);
        } else if (l == debug) {
            spdlog::debug("{}: {}", tag, [log UTF8String]);
        } else if (l == warn) {
            spdlog::warn("{}: {}", tag, [log UTF8String]);
        } else if (l == err) {
            spdlog::error("{}: {}", tag, [log UTF8String]);
        }
    }
}

void spdlog_reset_av_print_last_time() {
    audio_logger_last_time = 0;
    video_logger_last_time = 0;
}

void spdlog_audio_print(level_enum l, const char* tag, NSString* fmt, ...) {
    if (isInit) {
        spdlog::log_clock::time_point time_point_now = spdlog::details::os::now();
        spdlog::log_clock::duration duration_since_epoch = time_point_now.time_since_epoch();
        long long current_time_seconds = std::chrono::duration_cast<std::chrono::seconds>(duration_since_epoch).count();
        if (current_time_seconds - audio_logger_last_time <= LOG_WRITE_AV_DURATION) {
            return;
        }
        audio_logger_last_time = current_time_seconds;

        va_list args;
        va_start(args, fmt);
        NSString *log = [[NSString alloc] initWithFormat:fmt arguments:args];
        va_end(args);
        
        if (l == info) {
            audio_logger->info("{}: {}", tag, [log UTF8String]);
        } else if (l == debug) {
            audio_logger->debug("{}: {}", tag, [log UTF8String]);
        } else if (l == warn) {
            audio_logger->warn("{}: {}", tag, [log UTF8String]);
        } else if (l == err) {
            audio_logger->error("{}: {}", tag, [log UTF8String]);
        }
    }
}

void spdlog_video_print(level_enum l, const char* tag, NSString* fmt, ...) {
    if (isInit) {
        spdlog::log_clock::time_point time_point_now = spdlog::details::os::now();
        spdlog::log_clock::duration duration_since_epoch = time_point_now.time_since_epoch();
        long long current_time_seconds = std::chrono::duration_cast<std::chrono::seconds>(duration_since_epoch).count();
        if (current_time_seconds - video_logger_last_time <= LOG_WRITE_AV_DURATION) {
            return;
        }
        video_logger_last_time = current_time_seconds;

        va_list args;
        va_start(args, fmt);
        NSString *log = [[NSString alloc] initWithFormat:fmt arguments:args];
        va_end(args);
        
        if (l == info) {
            video_logger->info("{}: {}", tag, [log UTF8String]);
        } else if (l == debug) {
            video_logger->debug("{}: {}", tag, [log UTF8String]);
        } else if (l == warn) {
            video_logger->warn("{}: {}", tag, [log UTF8String]);
        } else if (l == err) {
            video_logger->error("{}: {}", tag, [log UTF8String]);
        }
    }
}

NSString* to_hex_string(const uint8_t* buf, int len, const NSString* separator) {
    std::string output;
    char temp[8];
    for (int i = 0; i < len; ++i)
    {
        sprintf(temp,"0x%.2x",(uint8_t)buf[i]);
        output.append(temp,4);
        output.append([separator UTF8String]);
    }
    NSString *ret = [NSString stringWithCString:output.c_str() encoding:[NSString defaultCStringEncoding]];
    return ret;
}

//std::string to_hex_string(const uint8_t* buf, int len, const std::string& separator)
//{
//    std::string output;
//    char temp[8];
//    for (int i = 0; i < len; ++i)
//    {
//        sprintf(temp,"0x%.2x",(uint8_t)buf[i]);
//        output.append(temp,4);
//        output.append(separator);
//    }
//
//    return output;
//}
