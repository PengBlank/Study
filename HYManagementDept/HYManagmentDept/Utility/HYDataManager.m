//
//  HYDataManager.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-21.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYDataManager.h"

@implementation HYDataManager

+ (instancetype)sharedManager
{
    static HYDataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[HYDataManager alloc] init];
    });
    return dataManager;
}

@end
