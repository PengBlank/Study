//
//  HYMallDelOrderResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-6-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallDelOrderResponse.h"

@implementation HYMallDelOrderResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.succ = ([GETOBJECTFORKEY(data, @"code", [NSString class]) intValue]==200);
    }
    
    return self;
}

@end
