//
//  HYVIPCardInfo.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYVIPCardInfo.h"

@implementation HYVIPCardInfo

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.number    = GETOBJECTFORKEY(data, @"number", [NSString class]);
        self.agency_name   = GETOBJECTFORKEY(data, @"agency_name", [NSString class]);
        self.status     = GETOBJECTFORKEY(data, @"status", [NSString class]);
        self.active_time    = GETOBJECTFORKEY(data, @"active_time", [NSString class]);
        self.enterprise_name = GETOBJECTFORKEY(data, @"enterprise_name", [NSString class]);
        self.promoters_name = GETOBJECTFORKEY(data, @"promoters_name", [NSString class]);
    }
    
    return self;
}

@end
