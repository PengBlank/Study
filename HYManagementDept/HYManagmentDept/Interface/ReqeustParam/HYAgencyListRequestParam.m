//
//  HYAgencyListRequestParam.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyListRequestParam.h"

@implementation HYAgencyListRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_agency_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.agecny_name length] > 0)
        {
            [newDic setObject:self.agecny_name forKey:@"agency_name"];
        }
    }
    
    return newDic;
}

- (HYRowDataResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAgencyListResponse *respose = [[HYAgencyListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
