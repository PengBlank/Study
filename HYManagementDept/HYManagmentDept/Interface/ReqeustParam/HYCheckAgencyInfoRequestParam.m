//
//  HYCheckAgencyInfoRequestParam.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCheckAgencyInfoRequestParam.h"

@implementation HYCheckAgencyInfoRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_agency_data"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCheckAgencyInfoResponse *respose = [[HYCheckAgencyInfoResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
