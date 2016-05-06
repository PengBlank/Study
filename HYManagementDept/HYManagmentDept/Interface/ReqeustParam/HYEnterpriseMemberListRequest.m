//
//  HYEnterpriseMemberListRequest.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYEnterpriseMemberListRequest.h"

@implementation HYEnterpriseMemberListRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/enterprise_member_list"];
        self.httpMethod = @"POST";
        _num_per_page = 20;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.number.length > 0)
        {
            [newDic setObject:_number
                       forKey:@"number"];
        }
        
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYEnterpriseMemberListResponse *respose = [[HYEnterpriseMemberListResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
