//
//  HYMallCartShopDropResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCartShopDropResponse.h"

@implementation HYMallCartShopDropResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSString *result = [GETOBJECTFORKEY(dictionary, @"data", [NSString class]) stringValue];
        _isDrop = [result boolValue];
    }
    
    return self;
}

@end
