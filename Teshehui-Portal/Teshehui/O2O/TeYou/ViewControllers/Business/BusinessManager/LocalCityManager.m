//
//  LocalCityManager.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "LocalCityManager.h"

@implementation LocalCityManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static LocalCityManager *__sharedManager = nil;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[LocalCityManager alloc] init];
    });
    return __sharedManager;
}

@end
