//
//  HYTaxiGetDidiOrderInfoReq.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiGetDidiOrderInfoReq.h"

@implementation HYTaxiGetDidiOrderInfoReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"traffic/didi/getDidiOrderInfo.action"];
        self.httpMethod = @"POST";
        self.businessType = @"22";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.didiOrderId) {
        [dict setObject:_didiOrderId forKey:@"didiOrderId"];
    }
    return dict;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYTaxiGetDidiOrderInfoResp *respose = [[HYTaxiGetDidiOrderInfoResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end
