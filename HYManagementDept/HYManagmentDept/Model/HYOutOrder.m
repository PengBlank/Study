//
//  HYOutOrder.m
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYOutOrder.h"

@implementation HYOutOrder

- (id)initWithDataInfo:(NSDictionary *)data
{
    if (self = [super init])
    {
        self.order_source = [GETOBJECTFORKEY(data, @"order_source", [NSString class]) intValue];
        self.order_no = GETOBJECTFORKEY(data, @"order_no", [NSString class]);
        self.created_time = GETOBJECTFORKEY(data, @"order_created_time", [NSString class]);
        self.number = GETOBJECTFORKEY(data, @"number", [NSString class]);
        id order_amout = [data objectForKey:@"order_amount"];
        if (order_amout) {
            self.order_amount = [order_amout floatValue];
        }
        //self.order_amount = [GETOBJECTFORKEY(data, @"order_amount", [NSString class]) floatValue];
        self.order_status = @"待结算";
        self.promoters_name = GETOBJECTFORKEY(data, @"promoters_name", [NSString class]);
    }
    return self;
}

@end
