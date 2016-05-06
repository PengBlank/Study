//
//  HYCardActiveFourFiveResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCardActiveFourFiveResponse.h"

@implementation HYCardActiveFourFiveResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSError *err;
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.userinfo = [[HYUserInfo alloc] initWithDictionary:data error:&err];
    }
    return self;
}

@end
