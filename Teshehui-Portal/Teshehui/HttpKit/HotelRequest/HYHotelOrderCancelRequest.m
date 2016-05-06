//
//  HYHotelOrderCancelRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderCancelRequest.h"
#import "HYHotelOrderCancelResponse.h"

@implementation HYHotelOrderCancelRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/cancelOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"03";
        self.reasonCode = @"1";
        self.reasonContent = @"取消订单测试";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.orderId length] > 0)
    {
        [newDic setObject:self.orderId forKey:@"orderId"];
        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        
        if ([self.reasonCode length] > 0)
        {
            [newDic setObject:self.reasonCode forKey:@"reasonCode"];
        }
        if ([self.reasonContent length] > 0)
        {
            [newDic setObject:self.reasonContent forKey:@"reasonContent"];
        }
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"酒店订单请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHotelOrderCancelResponse *respose = [[HYHotelOrderCancelResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
