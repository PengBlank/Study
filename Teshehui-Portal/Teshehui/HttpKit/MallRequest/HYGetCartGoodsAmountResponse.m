//
//  HYGetCartGoodsAmountResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetCartGoodsAmountResponse.h"

@implementation HYGetCartGoodsAmountResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.amount = [GETOBJECTFORKEY(data, @"totalQuantity", [NSString class]) integerValue];
    }
    
    return self;
}

@end
