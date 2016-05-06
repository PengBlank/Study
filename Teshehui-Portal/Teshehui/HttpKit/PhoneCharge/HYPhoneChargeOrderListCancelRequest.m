//
//  HYPhoneChargeOrderListCancelRequest.m
//  Teshehui
//
//  Created by HYZB on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneChargeOrderListCancelRequest.h"
#import "HYPhoneChargeOrderListCancelResponse.h"
#import "HYUserInfo.h"

@implementation HYPhoneChargeOrderListCancelRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/cancelOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"50";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    NSString *userid = [HYUserInfo getUserInfo].userId;
    if (userid.length > 0)
    {
        [data setObject:@(userid.integerValue) forKey:@"userId"];
    }
    
    if (self.orderId)
    {
        [data setObject:@(self.orderId) forKey:@"orderId"];
    }
    
    if (self.orderCode)
    {
        [data setObject:self.orderCode forKey:@"orderCode"];
    }
    
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPhoneChargeOrderListCancelResponse *respose = [[HYPhoneChargeOrderListCancelResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
