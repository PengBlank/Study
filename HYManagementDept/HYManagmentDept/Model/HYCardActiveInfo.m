//
//  HYCardActiveInfo.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-31.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCardActiveInfo.h"

@implementation HYCardActiveInfo

- (instancetype)initWithData:(NSDictionary *)data
{
    if (self = [super init])
    {
        self.m_id = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.number = GETOBJECTFORKEY(data, @"number", [NSString class]);
        self.password = GETOBJECTFORKEY(data, @"password", [NSString class]);
        self.agency_id = GETOBJECTFORKEY(data, @"agency_id", [NSString class]);
        self.deadline = GETOBJECTFORKEY(data, @"deadline", [NSString class]);
        NSString *status = GETOBJECTFORKEY(data, @"status", [NSString class]);
        self.m_status = [status integerValue];
        self.active_time = GETOBJECTFORKEY(data, @"active_time", [NSString class]);
        self.member_id = GETOBJECTFORKEY(data, @"member_id", [NSString class]);
        self.phone_mob = GETOBJECTFORKEY(data, @"phone_mob", [NSString class]);
    }
    return self;
}

@end
