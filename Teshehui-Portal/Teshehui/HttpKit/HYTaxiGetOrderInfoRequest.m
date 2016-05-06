//
//  HYTaxiGetOrderInfoRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiGetOrderInfoRequest.h"

@implementation HYTaxiGetOrderInfoRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/getOrderInfo.action"];
        self.httpMethod = @"POST";
        self.businessType = @"22";
        _isEnterprise = NO;
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.orderId) {
        [dict setObject:_orderId forKey:@"orderId"];
    }
    if (self.orderCode) {
        [dict setObject:_orderCode forKey:@"orderCode"];
    }
    if (self.userUserId) {
        [dict setObject:_userUserId forKey:@"userId"];
    }
    NSString* enterprise = _isEnterprise ? @"1" : @"0";
    [dict setObject:enterprise forKey:@"isEnterprise"];
    return dict;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYTaxiGetOrderInfoResponse *respose = [[HYTaxiGetOrderInfoResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
