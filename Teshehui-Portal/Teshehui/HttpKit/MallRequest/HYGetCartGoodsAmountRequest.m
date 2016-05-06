//
//  HYGetCartGoodsAmountRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetCartGoodsAmountRequest.h"

@implementation HYGetCartGoodsAmountRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/cart/countUserCartQuantity.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetCartGoodsAmountResponse *respose = [[HYGetCartGoodsAmountResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
