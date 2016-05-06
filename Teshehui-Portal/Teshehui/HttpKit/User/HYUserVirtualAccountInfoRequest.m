//
//  HYUserVirtualAccountInfoRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUserVirtualAccountInfoRequest.h"
#import "JSONKit_HY.h"
#import "HYUserInfo.h"

@implementation HYUserVirtualAccountInfoRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/queryUserVirtualAccountInfo.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSString *accountType = nil;
    if (_accountType == 0)
    {
        accountType = @"100";
    }
    else if (_accountType == 1)
    {
        accountType = @"200";
    }
    if (accountType.length > 0)
    {
        [data setObject:accountType forKey:@"accountType"];
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
    HYUserVirtualAccountResponse *respose = [[HYUserVirtualAccountResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
