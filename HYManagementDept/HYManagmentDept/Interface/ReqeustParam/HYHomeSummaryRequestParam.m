//
//  HYHomeSummaryRequestParam.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYHomeSummaryRequestParam.h"

@implementation HYHomeSummaryRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_count"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHomeSummaryRepsonse *respose = [[HYHomeSummaryRepsonse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
