//
//  HYMallOrderReturnResponse.m
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderReturnResponse.h"

@implementation HYMallOrderReturnResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSNumber *result = GETOBJECTFORKEY(dictionary, @"result", [NSNumber class]);
        self.result = [result boolValue];
    }
    
    return self;
}

@end
