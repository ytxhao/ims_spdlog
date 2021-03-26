//
// Created by yuhao on 3/18/21.
//

#ifndef IOS_MEDIA_STREAM_AMS_SPDLOG_H
#define IOS_MEDIA_STREAM_AMS_SPDLOG_H

#ifndef IMS_SPDLOG_LOGGER
#define IMS_SPDLOG_LOGGER

#define LEVEL_DEBUG 1
#define LEVEL_INFO 2
#define LEVEL_WARN 3
#define LEVEL_ERROR 4

enum level_enum
{
    debug = LEVEL_DEBUG,
    info = LEVEL_INFO,
    warn = LEVEL_WARN,
    err = LEVEL_ERROR,
};

#define SPDLOGI(TAG, fmt, ...) spdlog_normal_print(info, TAG, fmt, ##__VA_ARGS__)
#define SPDLOGD(TAG, fmt, ...) spdlog_normal_print(debug, TAG, fmt, ##__VA_ARGS__)
#define SPDLOGW(TAG, fmt, ...) spdlog_normal_print(warn, TAG, fmt, ##__VA_ARGS__)
#define SPDLOGE(TAG, fmt, ...) spdlog_normal_print(err, TAG, fmt, ##__VA_ARGS__)

#define SPDLOGAI(TAG, fmt, ...) spdlog_audio_print(info, TAG, fmt, ##__VA_ARGS__)
#define SPDLOGAD(TAG, fmt, ...) spdlog_audio_print(debug, TAG, fmt, ##__VA_ARGS__)
#define SPDLOGAW(TAG, fmt, ...) spdlog_audio_print(warn, TAG, fmt, ##__VA_ARGS__)
#define SPDLOGAE(TAG, fmt, ...) spdlog_audio_print(err, TAG, fmt, ##__VA_ARGS__)

#define SPDLOGVI(TAG, fmt, ...) spdlog_video_print(info, TAG, fmt, ##__VA_ARGS__)
#define SPDLOGVD(TAG, fmt, ...) spdlog_video_print(debug, TAG, fmt, ##__VA_ARGS__)
#define SPDLOGVW(TAG, fmt, ...) spdlog_video_print(warn, TAG, fmt, ##__VA_ARGS__)
#define SPDLOGVE(TAG, fmt, ...) spdlog_video_print(err, TAG, fmt, ##__VA_ARGS__)

#endif
NSString* to_hex_string(const uint8_t* buf, int len, const NSString* separator = @":");
void spdlog_reset_av_print_last_time();
void spdlog_normal_print(level_enum l, const char* tag, NSString* fmt, ...);
void spdlog_audio_print(level_enum l, const char* tag, NSString* fmt, ...);
void spdlog_video_print(level_enum l, const char* tag, NSString* fmt, ...);
void init_spdlog();
void deinit_spdlog();

#endif //ANDROID_MEDIA_STREAM_AMS_SPDLOG_H
