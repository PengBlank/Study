//
//  HYGetPayNORequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetPayNORequest.h"
#import "JSONKit_HY.h"

@implementation HYGetPayNORequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"pay/payConfirm.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSMutableDictionary *muTempDic = [[NSMutableDictionary alloc] init];
        
        if ([self.orderId length] > 0)
        {
            [muTempDic setObject:self.orderId forKey:@"orderId"];
        }
        if ([self.userId length] > 0)
        {
            [muTempDic setObject:self.userId forKey:@"userId"];
        }
        if (self.orderCode.length > 0)
        {
            [muTempDic setObject:self.orderCode forKey:@"orderCode"];
        }
        if (self.channelCode.length)
        {
            [muTempDic setObject:self.channelCode forKey:@"channelCode"];
        }
        if ([self.cardNumber length] > 0)
        {
            [muTempDic setObject:self.cardNumber forKey:@"userName"];
        }
        if ([self.walletAmount length]>0)
        {
            [muTempDic setObject:self.walletAmount
                          forKey:@"walletAmount"];
        }
        if ([self.orderAmount length]>0)
        {
            [muTempDic setObject:self.orderAmount
                          forKey:@"orderAmount"];
        }
        
        NSString *jsonData = [muTempDic JSONString];
        
        if (jsonData)
        {
            [newDic setObject:jsonData
                       forKey:@"data"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetPayNOResponse *respose = [[HYGetPayNOResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
