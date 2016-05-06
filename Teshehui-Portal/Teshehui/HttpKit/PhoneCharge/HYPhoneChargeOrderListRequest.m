//
//  HYPhoneChargeOrderListRequest.m
//  Teshehui
//
//  Created by HYZB on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneChargeOrderListRequest.h"
#import "HYPhoneChargeOrderListResponse.h"

@implementation HYPhoneChargeOrderListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/queryOrderList.action"];
        self.httpMethod = @"POST";
        self.businessType = @"50";
    }
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    if (self.userId)
    {
        [data setObject:self.userId forKey:@"userId"];
    }
    
    if (self.pageNo)
    {
        [data setObject:@(self.pageNo) forKey:@"pageNo"];
    }
    
    if (self.pageSize)
    {
        [data setObject:@(self.pageSize) forKey:@"pageSize"];
    }
    
    if (self.type)
    {
        [data setObject:self.type forKey:@"type"];
    }
    
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYPhoneChargeOrderListResponse alloc] initWithJsonDictionary:info];
}


@end
