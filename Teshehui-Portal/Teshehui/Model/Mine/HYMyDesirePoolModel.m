//
//  HYMyDesirePoolModel.m
//  Teshehui
//
//  Created by HYZB on 15/11/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesirePoolModel.h"

@implementation HYMyDesirePoolModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"id": @"d_id"}];
}

@end
