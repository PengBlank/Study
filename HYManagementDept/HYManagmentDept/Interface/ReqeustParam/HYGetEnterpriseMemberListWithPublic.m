//
//  HYGetEnterpriseMemberListWithPublic.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYGetEnterpriseMemberListWithPublic.h"

@implementation HYGetEnterpriseMemberListWithPublic
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/get_enterprise_member_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYEnterpriseMemberListPublicResponse *respose = [[HYEnterpriseMemberListPublicResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
