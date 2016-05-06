//
//  HYTaxiAddOrderRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiAddOrderRequest.h"

@implementation HYTaxiAddOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/addOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"22";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *data = [self.param toDictionary];
    [dict addEntriesFromDictionary:data];
    return dict;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYTaxiAddOrderResponse *respose = [[HYTaxiAddOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
