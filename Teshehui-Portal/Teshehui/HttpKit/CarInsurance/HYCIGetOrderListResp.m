//
//  HYCIGetOrderListResp.m
//  Teshehui
//
//  Created by HYZB on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetOrderListResp.h"

@implementation HYCIGetOrderListResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        if (items.count > 0)
        {
            self.orderList = [HYCIOrderDetail arrayOfModelsFromDictionaries:items];
        }
    }
    return self;
}

@end
