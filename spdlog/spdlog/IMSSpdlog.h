//
//  IMSSpdlog.h
//  StarMaker
//
//  Created by yuhao on 2021/3/10.
//  Copyright © 2021 uShow. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <spdlog/spdlog.h>
#ifndef IOS_SPDLOG_LOGGER
#define IOS_SPDLOG_LOGGER

#define SPDLOGI(TAG, fmt, ...) spdlog::info("{}: " fmt, TAG, ##__VA_ARGS__)
#define SPDLOGD(TAG, fmt, ...) spdlog::debug("{}: " fmt, TAG, ##__VA_ARGS__)
#define SPDLOGW(TAG, fmt, ...) spdlog::warn("{}: " fmt, TAG, ##__VA_ARGS__)
#define SPDLOGE(TAG, fmt, ...) spdlog::error("{}: " fmt, TAG, ##__VA_ARGS__)

#endif

void initSpdlog();
void deInitSpdlog();

