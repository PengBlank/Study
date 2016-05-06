//
//  HYHotelDelOrderRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-6-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDelOrderRequest.h"

@implementation HYHotelDelOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/deleteOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"03";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.userId length] > 0 &&
        [self.orderId length] > 0)
    {
        [newDic setObject:self.businessType forKey:@"businessType"];
        [newDic setObject:self.userId forKey:@"userId"];
        [newDic setObject:self.orderId forKey:@"orderId"];
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"删除酒店订单请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHotelDelOrderResponse *respose = [[HYHotelDelOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
