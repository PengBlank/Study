//
//  HYPromoteSellingRequest.m
//  Teshehui
//
//  Created by Kris on 15/9/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYPromoteSellingRequest.h"
#import "HYPromoteSellingResponse.h"
#import "JSONKit_HY.h"
#import "HYUserInfo.h"

@implementation HYPromoteSellingRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"promotion/productSpareAmount.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

//- (NSMutableDictionary *)getJsonDictionary
//{
//    NSMutableDictionary *dict = [super getJsonDictionary];
//    if (dict && ![dict isEqual:[NSNull null]])
//    {
//        if (_productSKUInfos.count > 0)
//        {
//            [dict setObject:@{@"productSKUArray": _productSKUInfos} forKey:@"data"];
//        }
//    }
//    return dict;
//}



- (NSDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (_productSKUInfos)
    {
        [data setObject:_productSKUInfos forKey:@"productSKUArray"];
    }
    NSString *userId = [HYUserInfo getUserInfo].userId;
    if (userId) {
        [data setObject:userId forKey:@"userId"];
    }
    if (self.settleType > 0)
    {
        [data setObject:@(_settleType) forKey:@"settleType"];
    }
    return data;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPromoteSellingResponse *respose = [[HYPromoteSellingResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
