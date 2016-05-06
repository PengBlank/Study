//
//  HYAgencyIncomeOrderListRequestParam.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyIncomeOrderListRequestParam.h"

@implementation HYAgencyIncomeOrderListRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_clearing_order_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.group length] > 0)
        {
            [newDic setObject:self.group forKey:@"group"];
        }
    }
    
    return newDic;
}

- (HYRowDataResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAgencyIncomeOrderListResponse *respose = [[HYAgencyIncomeOrderListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
