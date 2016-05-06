//
//  HYAddRechargeOrderRequest.m
//  Teshehui
//
//  Created by Kris on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYAddRechargeOrderRequest.h"
#import "HYAddRechargeOrderResponse.h"
#import "JSONKit_HY.h"

@implementation HYAddRechargeOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/addOrder.action"];
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
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        if (self.orderAmount.length > 0)
        {
            [tempDict setObject:self.orderAmount forKey:@"orderAmount"];
        }
        if (self.productCode.length > 0)
        {
            [tempDict setObject:self.productCode forKey:@"productCode"];
        }
        if (self.rechargeAmount.length > 0)
        {
            [tempDict setObject:self.rechargeAmount forKey:@"rechargeAmount"];
        }
        if (self.rechargeTelephone.length > 0)
        {
            [tempDict setObject:self.rechargeTelephone forKey:@"rechargeTelephone"];
        }
        if (self.rechargeType.length > 0)
        {
            [tempDict setObject:self.rechargeType forKey:@"rechargeType"];
        }
        if (self.userId.length > 0)
        {
            [tempDict setObject:self.userId forKey:@"userId"];
        }

        if (tempDict)
        {
            NSString *data = [tempDict JSONString];
            if (data.length > 0)
            {
                [newDic setObject:data forKey:@"data"];
            }
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAddRechargeOrderResponse *respose = [[HYAddRechargeOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
