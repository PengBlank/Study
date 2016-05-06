//
//  HYFlightStockReqeust.m
//  Teshehui
//
//  Created by 成才 向 on 15/6/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightStockReqeust.h"

@implementation HYFlightStockReqeust

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/getProductSKUStock.action"];
        self.httpMethod = @"POST";
        self.businessType = @"02";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        self.userId.length > 0 &&
        self.skuId.length > 0)
    {
        [newDic setObject:self.userId forKey:@"userId"];
        [newDic setObject:self.skuId forKey:@"productSKUId"];
    }
    else
    {
        DebugNSLog(@"机票可订查询缺少参数");
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlightStockResponse *respose = [[HYFlightStockResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
