//
//  HYCIGetOrderList.m
//  Teshehui
//
//  Created by HYZB on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetOrderListReq.h"
#import "JSONKit_HY.h"

@implementation HYCIGetOrderListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/queryOrderList.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
        self.pageSize = 20;
        self.businessType = @"06";
        self.version = @"1.0.1";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        if (self.orderType!=0)
        {
            [data setObject:@(self.orderType) forKey:@"orderStatus"];
        }
        if (self.userId)
        {
            [data setObject:self.userId forKey:@"userId"];
        }
        [data setObject:@(self.pageNo) forKey:@"pageNo"];
        [data setObject:@(self.pageSize) forKey:@"pageSize"];
        NSString *jsondata = [data JSONString];
        
        if ([jsondata length] > 0)
        {
            [newDic setObject:jsondata forKey:@"data"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCIGetOrderListResp *respose = [[HYCIGetOrderListResp alloc]initWithJsonDictionary:info];
    return respose;
}


@end
