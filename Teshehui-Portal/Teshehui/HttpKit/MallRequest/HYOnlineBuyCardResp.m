//
//  HYOnlineBuyCardResp.m
//  Teshehui
//
//  Created by HYZB on 14/11/4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYOnlineBuyCardResp.h"

@implementation HYOnlineBuyCardResp

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.order_id = GETOBJECTFORKEY(data, @"orderId", [NSString class]);
        self.order_no = GETOBJECTFORKEY(data, @"orderCode", [NSString class]);
        self.order_name = GETOBJECTFORKEY(data, @"orderName", [NSString class]);
        self.pay_total = GETOBJECTFORKEY(data, @"orderActualAmount", [NSString class]);
    }
    
    return self;
}

@end
