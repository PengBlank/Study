//
//  HYUserUpgradeResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/18.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUserUpgradeResponse.h"

@implementation HYUserUpgradeResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.orderId = GETOBJECTFORKEY(data, @"orderId", [NSString class]);
        self.orderNumber = GETOBJECTFORKEY(data, @"orderCode", [NSString class]);
//        self.orde = GETOBJECTFORKEY(data, @"orderName", [NSString class]);
        self.orderAmount = GETOBJECTFORKEY(data, @"orderActualAmount", [NSString class]);
    }
    return self;
}

@end
