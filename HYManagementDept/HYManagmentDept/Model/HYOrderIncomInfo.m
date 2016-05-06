//
//  HYOrderIncomInfo.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYOrderIncomInfo.h"

@implementation HYOrderIncomInfo

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.order_sn     = GETOBJECTFORKEY(data, @"order_sn", [NSString class]);
        self.company_name    = GETOBJECTFORKEY(data, @"company_name", [NSString class]);
        self.agency_name   = GETOBJECTFORKEY(data, @"agency_name", [NSString class]);
        self.order_amount    = GETOBJECTFORKEY(data, @"order_amount", [NSString class]);
        self.agency_profit   = GETOBJECTFORKEY(data, @"agency_profit", [NSString class]);
        self.company_profit     = GETOBJECTFORKEY(data, @"company_profit", [NSString class]);
        self.promoters_profit     = GETOBJECTFORKEY(data, @"promoters_profit", [NSString class]);
        self.order_create_time    = GETOBJECTFORKEY(data, @"order_create_time", [NSString class]);
        self.number    = GETOBJECTFORKEY(data, @"number", [NSString class]);
        self.order_brief   = GETOBJECTFORKEY(data, @"order_brief", [NSString class]);
        self.promoters_real_name = GETOBJECTFORKEY(data, @"promoters_real_name", [NSString class]);
        self.remark = GETOBJECTFORKEY(data, @"remark", [NSString class]);
        self.type = GETOBJECTFORKEY(data, @"type", [NSString class]);
    }
    
    return self;
}

@end
