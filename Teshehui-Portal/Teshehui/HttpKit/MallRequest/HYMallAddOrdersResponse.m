//
//  HYMallAddOrdersResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallAddOrdersResponse.h"

@implementation HYMallAddOrdersResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
//        self.result = [GETOBJECTFORKEY(dictionary, @"done", [NSString class]) boolValue];
        self.msg = GETOBJECTFORKEY(dictionary, @"msg", [NSString class]);
        
//        NSDictionary *carInfo = GETOBJECTFORKEY(dictionary, @"cart", [NSDictionary class]);
//        self.quantity = [GETOBJECTFORKEY(carInfo, @"quantity", [NSString class]) integerValue];
//        self.amount = [GETOBJECTFORKEY(carInfo, @"amount", [NSString class]) integerValue];
    }
    
    return self;
}

@end
