//
//  HYTaxiCancelOrderReq.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiCancelOrderReq.h"

@implementation HYTaxiCancelOrderReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/cancelOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"22";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.orderCode) {
        [dict setObject:_orderCode forKey:@"orderCode"];
    }
    if (self.userId) {
        [dict setObject:self.userId forKey:@"userId"];
    }
    
    [dict setObject:_isForceCancel ? @"1":@"0" forKey:@"isForceCancel"];
    return dict;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYTaxiCancelOrderResp *respose = [[HYTaxiCancelOrderResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end
