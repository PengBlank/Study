//
//  HYAgencyIncomeRequestParam.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCompanyIncomeRequestParam.h"

@implementation HYCompanyIncomeRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_company_clearing"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
    }
    
    return newDic;
}

- (HYRowDataResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCompanyIncomeResponse *respose = [[HYCompanyIncomeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
