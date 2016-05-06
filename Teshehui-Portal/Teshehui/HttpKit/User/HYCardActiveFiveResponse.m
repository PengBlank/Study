//
//  HYCardActiveFiveResponse.m
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCardActiveFiveResponse.h"

@implementation HYCardActiveFiveResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSError *err;
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.userinfo = [[HYUserInfo alloc] initWithDictionary:data error:&err];
        if (err) {
            assert(NO);
        }
    }
    return self;
}

@end
