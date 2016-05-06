//
//  HYMallCartShopUpdateRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCartShopUpdateRequest.h"
#import "HYMallCartShopUpdateResponse.h"

@implementation HYMallCartShopUpdateRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"cart/editUserCart.action"];
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
        
        if (self.editType.length > 0)
        {
            [newDic setObject:_editType forKey:@"editType"];
        }
        
        if (self.anotherSKUId.length > 0)
        {
            [newDic setObject:self.anotherSKUId forKey:@"newProductSKUId"];
        }
        
        if ([self.quantity length] > 0)
        {
            [newDic setObject:self.quantity forKey:@"quantity"];
        }
        
        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallCartShopUpdateResponse *respose = [[HYMallCartShopUpdateResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
