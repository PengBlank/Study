//
//  HYEnterpriseMember.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYEnterpriseMember.h"

@implementation HYEnterpriseMember
- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init]) {
        self.user_id = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
        self.number = GETOBJECTFORKEY(data, @"number", [NSString class]);
        self.real_name = GETOBJECTFORKEY(data, @"real_name", [NSString class]);
        self.phone_mob = GETOBJECTFORKEY(data, @"phone_mob", [NSString class]);
        self.id_card = GETOBJECTFORKEY(data, @"id_card", [NSString class]);
        self.name = GETOBJECTFORKEY(data, @"name", [NSString class]);
    }
    
    return self;
}
@end
