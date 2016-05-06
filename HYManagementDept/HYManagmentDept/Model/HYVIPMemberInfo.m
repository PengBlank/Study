//
//  HYVIPMemberInfo.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYVIPMemberInfo.h"

@implementation HYVIPMemberInfo

- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init]) {
        self.number = GETOBJECTFORKEY(data, @"number", [NSString class]);
        self.real_name = GETOBJECTFORKEY(data, @"real_name", [NSString class]);
        self.phone_mob = GETOBJECTFORKEY(data, @"phone_mob", [NSString class]);
        self.id_card = GETOBJECTFORKEY(data, @"id_card", [NSString class]);
        self.name = GETOBJECTFORKEY(data, @"name", [NSString class]);
        self.m_id = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.enterprise_name = GETOBJECTFORKEY(data, @"enterprise_name", [NSString class]);
        self.promoters_name = GETOBJECTFORKEY(data, @"promoters_name", [NSString class]);
        self.reg_time = GETOBJECTFORKEY(data, @"reg_time", NSString);
    }
    
    return self;
}

@end
