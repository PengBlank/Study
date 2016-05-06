//
//  HYPhoneChargeOrderListDeleteRequest.m
//  Teshehui
//
//  Created by HYZB on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneChargeOrderListDeleteRequest.h"
#import "HYPhoneChargeOrderListDeleteResponse.h"

@implementation HYPhoneChargeOrderListDeleteRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/deleteOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"50";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.orderId)
        {
            [newDic setObject:@(self.orderId) forKey:@"orderId"];
        }
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPhoneChargeOrderListDeleteResponse *respose = [[HYPhoneChargeOrderListDeleteResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
