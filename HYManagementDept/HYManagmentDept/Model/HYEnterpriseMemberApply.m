//
//  HYEnterpriseMemberApply.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYEnterpriseMemberApply.h"

@implementation HYEnterpriseMemberApply
- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init]) {
        self.m_id = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.enterprise_id = GETOBJECTFORKEY(data, @"enterprise_id", [NSString class]);
        self.status = [GETOBJECTFORKEY(data, @"status", [NSString class]) integerValue];
        self.status_txt = GETOBJECTFORKEY(data, @"status_txt", [NSString class]);
        self.desc = GETOBJECTFORKEY(data, @"description", [NSString class]);
        self.created = GETOBJECTFORKEY(data, @"created", [NSString class]);
        self.agency_approve_time = GETOBJECTFORKEY(data, @"agency_approve_time", [NSString class]);
        self.agency_approve_desc = GETOBJECTFORKEY(data, @"agency_approve_desc", [NSString class]);
        self.company_approve_time = GETOBJECTFORKEY(data, @"company_approve_time", [NSString class]);
        self.company_approve_desc = GETOBJECTFORKEY(data, @"company_approve_desc", [NSString class]);
        self.finance_approve_time = GETOBJECTFORKEY(data, @"finance_approve_time", [NSString class]);
        self.finance_approve_desc = GETOBJECTFORKEY(data, @"finance_approve_desc", [NSString class]);
        self.total_member = [GETOBJECTFORKEY(data, @"total_member", NSString) longLongValue];
        self.enterprise_name = GETOBJECTFORKEY(data, @"enterprise_name", [NSString class]);
    }
    
    return self;
}

- (HYEtAppStatus)appStatus
{
    return _status;
}

@end
