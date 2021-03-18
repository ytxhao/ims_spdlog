//
//  IMSSpdlog.m
//  StarMaker
//
//  Created by yuhao on 2021/3/10.
//  Copyright © 2021 uShow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMSSpdlog.h"
#include <spdlog/spdlog.h>
#include <spdlog/sinks/rotating_file_sink.h>
#include <spdlog/sinks/ios_sink.h>
#define TAG "IMSSpdlog"

static bool isInit = false;

NSString *logFileOutputPath() {
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
    return [NSString stringWithFormat:@"%@/%@", pathString, @"ims_rotating.txt"];;
}

void initSpdlog() {
    if (isInit == false) {
        NSString *path = logFileOutputPath();
        std::string file([path UTF8String]);
        spdlog::set_level(spdlog::level::debug);
        
        auto file_sink = std::make_shared<spdlog::sinks::rotating_file_sink_mt>(file,1024 * 1024 * 5,3);
        file_sink->set_pattern("%Y-%m-%d %H:%M:%S.%e %P-%t %L/%v");

        auto ios_sink = std::make_shared<spdlog::sinks::ios_sink_mt>(true);
        ios_sink->set_pattern("%v");
        
        std::vector<spdlog::sink_ptr> sinks;
        sinks.push_back(file_sink);
        sinks.push_back(ios_sink);
        
        auto combined_logger = std::make_shared<spdlog::logger>( "multi_sink", begin( sinks ), end( sinks ));
        spdlog::set_default_logger(combined_logger);
        std::chrono::seconds s(2);
        spdlog::flush_every(s);
        SPDLOGI(TAG,"initSpdlog filePath:{}", file);
        isInit = true;
    }
}

void deInitSpdlog() {
    if (isInit == true) {
        SPDLOGI(TAG,"deInitSpdlog");
        spdlog::drop_all();
    }
}
