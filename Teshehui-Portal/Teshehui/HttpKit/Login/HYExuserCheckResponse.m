//
//  HYExuserCheckResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExuserCheckResponse.h"

@implementation HYExuserCheckResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSString *data = GETOBJECTFORKEY(dictionary, @"data", NSString);
        self.registered = [data boolValue];
    }
    return self;
}

@end
