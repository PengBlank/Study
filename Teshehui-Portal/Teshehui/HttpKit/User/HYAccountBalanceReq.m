//
//  HYAccountBalanceReq.m
//  Teshehui
//
//  Created by Kris on 15/8/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAccountBalanceReq.h"
#import "JSONKit_HY.h"
#import "HYAccountBalanceResponse.h"
#import "HYUserInfo.h"

@implementation HYAccountBalanceReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/queryUserCashAccountTradeStream.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic)
    {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        NSString *tradeType = nil;
        
        if (tradeType.length > 0)
        {
            [data setObject:tradeType forKey:@"tradeType"];
        }
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid.length > 0)
        {
            [data setObject:userid forKey:@"userId"];
        }
        if (_pageNo.length > 0)
        {
            [data setObject:_pageNo forKey:@"pageNo"];
        }
        if (_pageSize.length > 0)
        {
            [data setObject:_pageSize forKey:@"pageSize"];
        }
        NSString *datastring = [data JSONString];
        [newDic setObject:datastring forKey:@"data"];
    }
    
    return newDic;
}

- (HYAccountBalanceResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAccountBalanceResponse *respose = [[HYAccountBalanceResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
