//
//  HYFlightOrderListRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderListRequest.h"

@implementation HYFlightOrderListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/orderList.action"];
        self.httpMethod = @"POST";
        self.businessType = @"02";
        _page = 1;
        _page_size = 20;
        _is_enterprise = 0;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.user_id length] > 0)
        {
            [newDic setObject:self.user_id forKey:@"userId"];
        }
        
        if ([self.employeeId length] > 0)
        {
            [newDic setObject:self.employeeId
                       forKey:@"employeeId"];
        }
        
        if ([self.start_date length] > 0)
        {
            [newDic setObject:self.start_date forKey:@"startTime"];
        }
        
        if (self.order_code.length > 0)
        {
            [newDic setObject:self.order_code forKey:@"orderCode"];
        }
        
        if ([self.end_date length] > 0)
        {
            [newDic setObject:self.end_date forKey:@"endTime"];
        }
        
        [newDic setObject:[NSNumber numberWithInteger:self.is_enterprise]
                   forKey:@"isEnterprise"];
        
        [newDic setObject:[NSString stringWithFormat:@"%d", (int)self.page]
                   forKey:@"pageNo"];
        [newDic setObject:[NSString stringWithFormat:@"%d", (int)self.page_size]
                   forKey:@"pageSize"];
//        [newDic setObject:[NSString stringWithFormat:@"%d", self.is_enterprise]
//                   forKey:@"is_enterprise"];
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"查询机票订单列表");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlightOrderListResponse *respose = [[HYFlightOrderListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
