//
//  HYMallCartShopDropRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCartShopDropRequest.h"
#import "HYMallCartShopDropResponse.h"
#import "JSONKit_HY.h"

@implementation HYMallCartShopDropRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"cart/deleteUserCart.action"];
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
        if ([self.productSKUIds count] > 0)
        {
            NSString *skuidjson = [self.productSKUIds JSONString];
            [newDic setObject:skuidjson forKey:@"productSKUId"];
        }
        
        if (self.userId)
        {
            [newDic setObject:self.userId
                       forKey:@"userId"];
        }
        [newDic setObject:self.businessType
                   forKey:@"businessType"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallCartShopDropResponse *respose = [[HYMallCartShopDropResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
