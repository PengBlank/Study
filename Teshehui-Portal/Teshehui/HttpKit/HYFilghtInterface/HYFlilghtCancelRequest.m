//
//  HYFlilghtCancelRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlilghtCancelRequest.h"

@implementation HYFlilghtCancelRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/cancelOrder.action"];
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
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"取消订单 缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlilghtCancelResponse *respose = [[HYFlilghtCancelResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
