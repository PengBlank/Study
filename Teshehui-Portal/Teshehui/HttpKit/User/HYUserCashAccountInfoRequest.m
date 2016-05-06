//
//  HYUserCashAccountInfoRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUserCashAccountInfoRequest.h"
#import "JSONKit_HY.h"
#import "HYUserInfo.h"

@implementation HYUserCashAccountInfoRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/queryUserCashAccountInfo.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
        
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSString *accountType = nil;
    if (_currencyType == 0)
    {
        accountType = @"01";
    }
    if (accountType.length > 0)
    {
        [data setObject:accountType forKey:@"currencyTypeCode"];
    }
    NSString *userid = [HYUserInfo getUserInfo].userId;
    if (userid.length > 0)
    {
        [data setObject:userid forKey:@"userId"];
    }
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYUserCashAccountInfoResponse *respose = [[HYUserCashAccountInfoResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
