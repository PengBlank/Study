//
//  TravleManager.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TravleManager.h"

@implementation TravleManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static TravleManager *__sharedManager = nil;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[TravleManager alloc] init];
    });
    return __sharedManager;
}
@end
