//
//  HYTaxiOrderListRequest.m
//  Teshehui
//
//  Created by HYZB on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiOrderListRequest.h"
#import "HYTaxiOrderListResponse.h"

@implementation HYTaxiOrderListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/queryOrderList.action"];
        self.httpMethod = @"POST";
        self.businessType = @"22";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.type) {
        [data setObject:self.type forKey:@"type"];
    }
    if (self.userId) {
        [data setObject:self.userId forKey:@"userId"];
    }
    if (self.pageNo) {
        [data setObject:self.pageNo forKey:@"pageNo"];
    }
    if (self.pageSize) {
        [data setObject:self.pageSize forKey:@"pageSize"];
    }
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    
    HYTaxiOrderListResponse *response = [[HYTaxiOrderListResponse alloc] initWithJsonDictionary:info];
    return response;
}

@end
