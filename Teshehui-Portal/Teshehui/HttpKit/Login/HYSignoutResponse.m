//
//  HYSignoutResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYSignoutResponse.h"

@implementation HYSignoutResponse
- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSNumber *result = GETOBJECTFORKEY(dictionary, @"data", [NSNumber class]);
        _data = [result boolValue];
    }
    
    return self;
}

@end
