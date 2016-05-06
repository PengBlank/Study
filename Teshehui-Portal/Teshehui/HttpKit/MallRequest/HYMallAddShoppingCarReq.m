//
//  HYMallAddOrdersResquest.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallAddShoppingCarReq.h"

@implementation HYMallAddShoppingCarReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"cart/addUserCart.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.productSKUId length] > 0)
        {
            [newDic setObject:self.productSKUId forKey:@"productSKUId"];
        }
        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        [newDic setObject:self.businessType forKey:@"businessType"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.quantity]
                   forKey:@"quantity"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallAddOrdersResponse *respose = [[HYMallAddOrdersResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
