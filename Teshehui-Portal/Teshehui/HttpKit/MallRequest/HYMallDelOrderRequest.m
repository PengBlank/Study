//
//  HYMallDelOrderRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-6-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallDelOrderRequest.h"
#import "HYUserInfo.h"

@implementation HYMallDelOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/deleteOrder.action"];
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
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid.length > 0)
        {
            [newDic setObject:userid forKey:@"userId"];
        }
        [newDic setObject:self.businessType forKey:@"businessType"];
        if (self.order_code.length > 0)
        {
            [newDic setObject:self.order_code
                       forKey:@"orderCode"];
        }
//        if (self.order_id.length > 0)
//        {
//            [newDic setObject:self.order_id
//                       forKey:@"orderId"];
//        }
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallDelOrderResponse *respose = [[HYMallDelOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
