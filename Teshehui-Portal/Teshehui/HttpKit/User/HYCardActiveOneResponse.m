//
//  HYCardActiveOneResponse.m
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCardActiveOneResponse.h"

@implementation HYCardActiveOneResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.info = [[HYActivateInfo alloc] initWithDictionary:data error:nil];
    }
    return self;
}

@end
