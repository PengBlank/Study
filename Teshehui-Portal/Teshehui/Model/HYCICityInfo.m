//
//  HYCICityInfo.m
//  Teshehui
//
//  Created by HYZB on 15/7/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCICityInfo.h"

@implementation HYCICityInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"cId"}];
}

@end
