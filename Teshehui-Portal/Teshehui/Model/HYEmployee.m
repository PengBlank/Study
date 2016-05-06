//
//  HYEmployee.m
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYEmployee.h"

@implementation HYEmployee

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.user_id    = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
        self.number   = GETOBJECTFORKEY(data, @"number", [NSString class]);
        self.real_name    = GETOBJECTFORKEY(data, @"real_name", [NSString class]);
        self.phone_mob  = GETOBJECTFORKEY(data, @"phone_mob", [NSString class]);
        self.policy_end  = GETOBJECTFORKEY(data, @"policy_end", [NSString class]);
    }
    
    return self;
}

@end
