//
//  HYActivateUserReponse.m
//  Teshehui
//
//  Created by ichina on 14-3-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYActivateUserReponse.h"

@implementation HYActivateUserReponse
- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSError *err;
        NSDictionary* dic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        _info = [[HYUserInfo alloc] initWithDictionary:dic error:&err];
        if (err)
        {
            assert(NO);
        }
    }
    
    return self;
}
@end
