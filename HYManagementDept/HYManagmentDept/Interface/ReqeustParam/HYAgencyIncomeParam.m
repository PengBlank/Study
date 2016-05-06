//
//  HYAgencyIncomeParam.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyIncomeParam.h"
#import "HYAgencyIncomeResponse.h"

@implementation HYAgencyIncomeParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_clearing_agency_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
//        [newDic setObject:[NSString stringWithFormat:@"%d", self.num_per_page]
//                   forKey:@"num_per_page"];
//        [newDic setObject:[NSString stringWithFormat:@"%d", self.page]
//                   forKey:@"page"];
    }
    
    return newDic;
}

- (HYRowDataResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAgencyIncomeResponse *respose = [[HYAgencyIncomeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
