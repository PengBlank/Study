//
//  HYFlightInvoiceRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightInvoiceRequest.h"

@implementation HYFlightInvoiceRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kFlightRequestBaseURL, @"api/Order/rise_cabin/"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.order_no length] > 0 &&
        [self.passengers length] > 0 &&
        [self.contact length] > 0 &&
        [self.tel length] > 0 &&
        [self.zip_code length] > 0 &&
        [self.province length] > 0 &&
        [self.address length] > 0 &&
        [self.city length] > 0)
    {
        if ([self.user_id length] > 0)
        {
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
        
        [newDic setObject:self.order_no forKey:@"order_no"];
        [newDic setObject:self.passengers forKey:@"passengers"];
        
        [newDic setObject:self.contact forKey:@"contact"];
        [newDic setObject:self.tel forKey:@"tel"];
        [newDic setObject:self.zip_code forKey:@"zip_code"];
        [newDic setObject:self.province forKey:@"province"];
        [newDic setObject:self.address forKey:@"address"];
        [newDic setObject:self.city forKey:@"city"];
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"订单行程单申请 缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlightInvoiceResponse *respose = [[HYFlightInvoiceResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
