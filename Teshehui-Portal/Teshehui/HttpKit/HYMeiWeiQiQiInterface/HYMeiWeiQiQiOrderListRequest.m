//
//  HYMeiWeiQiQiOrderListRequest.m
//  Teshehui
//
//  Created by HYZB on 15/12/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMeiWeiQiQiOrderListRequest.h"
#import "HYUserInfo.h"
#import "HYMeiWeiQiQiOrderListResponse.h"

@implementation HYMeiWeiQiQiOrderListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/queryOrderList.action"];
        self.httpMethod = @"POST";
        self.businessType = @"41";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    self.userId = [HYUserInfo getUserInfo].userId;
    if (self.userId)
    {
        [data setObject:self.userId forKey:@"userId"];
    }
    
    if (self.type)
    {
        [data setObject:self.type forKey:@"type"];
    }
    
    if (self.pageNo)
    {
        [data setObject:self.pageNo forKey:@"pageNo"];
    }
    
    if (self.pageSize)
    {
        [data setObject:self.pageSize forKey:@"pageSize"];
    }
    
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMeiWeiQiQiOrderListResponse *respose = [[HYMeiWeiQiQiOrderListResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
