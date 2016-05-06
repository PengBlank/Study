//
//  HYSearchMemberTelRequestParam.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSearchMemberTelRequestParam.h"

@implementation HYSearchMemberTelRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_ajax_search_member_tel"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.number length] > 0) {
            
            [newDic setObject:self.number forKey:@"number"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYSearchMemberTelResponse *respose = [[HYSearchMemberTelResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
