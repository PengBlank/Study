//
//  HYFlowerOrderInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerOrderInfo.h"

@implementation HYFlowerOrderInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.orderID = GETOBJECTFORKEY(data, @"orderId", [NSString class]);
        self.order_id = GETOBJECTFORKEY(data, @"orderId", [NSString class]);
        self.order_no = GETOBJECTFORKEY(data, @"orderCode", [NSString class]);
        self.created = GETOBJECTFORKEY(data, @"created", [NSString class]);
        self.receiver_name = GETOBJECTFORKEY(data, @"receiver_name", [NSString class]);
        self.receiver_phone = GETOBJECTFORKEY(data, @"receiver_phone", [NSString class]);
        self.province = GETOBJECTFORKEY(data, @"province", [NSString class]);
        self.city = GETOBJECTFORKEY(data, @"city", [NSString class]);
        self.district = GETOBJECTFORKEY(data, @"district", [NSString class]);
        self.receiver_address = GETOBJECTFORKEY(data, @"receiver_address", [NSString class]);
        self.pay_total = GETOBJECTFORKEY(data, @"orderTotalAmount", [NSString class]);
        self.total_amount = GETOBJECTFORKEY(data, @"orderTotalAmount", [NSString class]);
        self.order_status = [GETOBJECTFORKEY(data, @"status", [NSString class]) intValue];
        
        self.user_name = GETOBJECTFORKEY(data, @"user_name", [NSString class]);
        self.order_type = [GETOBJECTFORKEY(data, @"order_type", [NSString class]) integerValue];
    }
    
    return self;
}
@end
