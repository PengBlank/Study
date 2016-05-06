//
//  HYSignInResponse.m
//  Teshehui
//
//  Created by HYZB on 16/3/28.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYSignInResponse.h"

@implementation HYSignInResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.currentSignNum = data[@"currentSignNum"];
    }
    return self;
}

@end
