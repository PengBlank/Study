//
//  HYFlightGetOrderInfoRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightGetOrderInfoRequest.h"

@implementation HYFlightGetOrderInfoRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/getOrderDetail.action"];
        self.httpMethod = @"POST";
        self.businessType = @"02";
        
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.orderCode length] > 0)
    {
        if ([self.user_id length] > 0)
        {
            [newDic setObject:self.user_id forKey:@"userId"];
        }

        [newDic setObject:self.orderCode forKey:@"orderCode"];
        
        
        if ([self.employeeId length] > 0)
        {
            [newDic setObject:self.employeeId forKey:@"employeeId"];
        }
        
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.isEnterprise]
                   forKey:@"isEnterprise"];
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"查询用户单个订单详细");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlightGetOrderInfoResponse *respose = [[HYFlightGetOrderInfoResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
