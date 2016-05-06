//
//  HYCardActiveTwoResponse.m
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCardActiveTwoResponse.h"

@implementation HYCardActiveTwoResponse

//@synthesize code = _code;

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.checkCode = GETOBJECTFORKEY(data, @"checkCode", NSString);
    }
    return self;
}

@end
