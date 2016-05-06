//
//  HYCoinAccountRequest.m
//  Teshehui
//
//  Created by Kris on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCoinAccountRequest.h"
#import "HYCoinAccountResponse.h"
#import "HYUserInfo.h"

@implementation HYCoinAccountRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/user/queryUserVirtualAccountTradeStream.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"pageNo"];
    [data setObject:[NSString stringWithFormat:@"%ld",self.num_per_page] forKey:@"pageSize"];
    
    //交易类不为0时才有，否则为全部
    if (self.tradeType != 0)
    {
        NSString *tradeType = [NSString stringWithFormat:@"0%d", (int)self.tradeType];
        
        [data setObject:tradeType forKey:@"tradeType"];
    }
    NSString *acountType = nil;
    if (self.acountType == 0)
    {
        acountType = @"100";
    }
    else if (_acountType == 1)
    {
        acountType = @"200";
    }
    if (acountType)
    {
        [data setObject:acountType forKey:@"accountType"];
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
    HYCoinAccountResponse *respose = [[HYCoinAccountResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
