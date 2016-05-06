//
//  HYMallCartShopRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetShoppingCarRequest.h"
#import "HYMallCartShopResponse.h"

@implementation HYGetShoppingCarRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"cart/queryUserCart.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.productServiceVersion = @"1.0.0";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        if ([self.businessType length] > 0)
        {
            [newDic setObject:self.businessType forKey:@"businessType"];
        }
        if ([self.productServiceVersion length] > 0)
        {
            [newDic setObject:self.productServiceVersion forKey:@"productServiceVersion"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallCartShopResponse *respose = [[HYMallCartShopResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
