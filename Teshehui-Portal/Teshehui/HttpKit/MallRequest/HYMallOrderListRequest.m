//
//  HYMallOrderListRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderListRequest.h"
#import "HYMallOrderListResponse.h"

@implementation HYMallOrderListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/orderList.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.version = @"1.0.1";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageNo]
                   forKey:@"pageNo"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageSize]
                   forKey:@"pageSize"];
        
//        if ([self.type length] > 0)
        {
            [newDic setObject:@(_type) forKey:@"type"];
        }

        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        
        if (self.startTime > 0)
        {
            [newDic setObject:self.startTime
                       forKey:@"startTime"];
        }
        
        if (self.endTime > 0)
        {
            [newDic setObject:self.endTime
                       forKey:@"endTime"];
        }
        
        [newDic setObject:self.businessType
                   forKey:@"businessType"];
        
        if ([_orderCode length] > 0)
        {
            [newDic setObject:self.orderCode
                       forKey:@"orderCode"];
        }
    }
    
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallOrderListResponse *respose = [[HYMallOrderListResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
