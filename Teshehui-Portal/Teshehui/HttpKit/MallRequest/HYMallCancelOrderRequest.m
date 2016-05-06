//
//  HYMallCancelOrderRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCancelOrderRequest.h"
#import "HYMallCancelOrderReponse.h"
#import "HYUserInfo.h"

@implementation HYMallCancelOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/cancelOrder.action"];
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
        
        if ([self.order_code length] > 0)
        {
            [newDic setObject:self.order_code forKey:@"orderCode"];
        }
//        if ([self.order_id length] > 0)
//        {
//            [newDic setObject:self.order_id forKey:@"orderId"];
//        }
//        if ([self.cancel_reason length] > 0)
//        {
//            [newDic setObject:self.cancel_reason forKey:@"reasonContent"];
//        }
//        if ([self.cancel_reason_code length] > 0)
//        {
//            [newDic setObject:self.cancel_reason_code forKey:@"reasonCode"];
//        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallCancelOrderReponse *respose = [[HYMallCancelOrderReponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
