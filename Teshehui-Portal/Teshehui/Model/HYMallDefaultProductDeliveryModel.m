//
//  HYMallDefaultProductDeliveryModel.m
//  Teshehui
//
//  Created by HYZB on 15/12/31.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallDefaultProductDeliveryModel.h"

@implementation HYMallDefaultProductDeliveryModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"deliveryId"}];
}

@end
