//
//  HYUserUpgradeRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/18.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUserUpgradeRequest.h"
#import "JSONKit_HY.h"
#import "HYUserInfo.h"

@implementation HYUserUpgradeRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/order/memberUpgrade.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.businessType = BusinessType_Mall;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *json = [super getJsonDictionary];
    
    if (json)
    {
        if (self.orderType)
        {
            [json setObject:_orderType forKey:@"orderType"];
        }
        
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid.length > 0)
        {
            [json setObject:userid forKey:@"userId"];
        }
        
        if (self.isBuypolicy)
        {
            [json setObject:self.isBuypolicy forKey:@"isBuyPolicy"];
        }
        if (self.isBuypolicy.boolValue)
        {
            if (self.policyType)
            {
                [json setObject:self.policyType forKey:@"policyType"];
            }
            if (self.realName) {
                [json setObject:_realName forKey:@"realName"];
            }
            if (self.certificateCode) {
                [json setObject:_certificateCode forKey:@"certificateCode"];
            }
            if (self.certificateNumber) {
                [json setObject:_certificateNumber forKey:@"certificateNumber"];
            }
            [json setObject:@(_sex) forKey:@"sex"];
            if (self.birthday) {
                [json setObject:_birthday forKey:@"birthday"];
            }
            if (self.mobilephone) {
                [json setObject:_mobilephone forKey:@"mobilephone"];
            }
        }
    }
    
    return json;
}

//- (NSMutableDictionary *)getDataDictionary
//{
//    NSMutableDictionary *data = [NSMutableDictionary dictionary];
//    
//    
//    return data;
//}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYUserUpgradeResponse *respose = [[HYUserUpgradeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
