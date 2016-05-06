//
//  HYPayWaysResponse.m
//  Teshehui
//
//  Created by Kris on 15/5/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYPayWaysResponse.h"

@implementation HYPayWays

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.status = GETOBJECTFORKEY(data, @"status", [NSString class]);
        NSDictionary *orderData = GETOBJECTFORKEY(data, @"data", [NSDictionary class]);
        if (orderData)
        {
            self.order_id = GETOBJECTFORKEY(orderData, @"id", [NSString class]);
            self.order_sn = GETOBJECTFORKEY(orderData, @"order_sn", [NSString class]);
            self.voucher_code = GETOBJECTFORKEY(orderData, @"voucher_code", [NSString class]);
            self.voucher_name = GETOBJECTFORKEY(orderData, @"voucher_name", [NSString class]);
            self.merchant_id = GETOBJECTFORKEY(orderData, @"merchant_id", [NSString class]);
            self.merchant_name = GETOBJECTFORKEY(orderData, @"merchant_name", [NSString class]);
            self.order_amount = GETOBJECTFORKEY(orderData, @"order_amount", [NSString class]);
            self.points = GETOBJECTFORKEY(orderData, @"points", [NSString class]);
            self.buyer_id = GETOBJECTFORKEY(orderData, @"buyer_id", [NSString class]);
            self.created = GETOBJECTFORKEY(orderData, @"created", [NSString class]);
        }
    }
    return self;
}

@end

@implementation HYPayWaysResponse
-(id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        _payWays = [[HYPayWays alloc]initWithDataInfo:dictionary];
    }
    return self;
}
@end
