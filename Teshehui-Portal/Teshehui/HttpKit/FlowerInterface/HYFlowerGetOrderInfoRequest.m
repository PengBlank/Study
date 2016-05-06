//
//  HYGetOrderInfoRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerGetOrderInfoRequest.h"

@implementation HYFlowerGetOrderInfoRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kFlowerRequestBaseURL, @"api/orders/GetOrderInfoWithProducts"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.OrderNo length] > 0)
        {
            [newDic setObject:self.OrderNo forKey:@"OrderNo"];
        }
        
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.IsEnterprise]
                   forKey:@"IsEnterprise"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlowerGetOrderInfoResponse *respose = [[HYFlowerGetOrderInfoResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
