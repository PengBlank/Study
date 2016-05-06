//
//  HYAgencyCountRequest.m
//  HYManagmentDept
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "HYAgencyCountRequest.h"

@implementation HYAgencyCountRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_agency_count"];
        self.httpMethod = @"POST";
        self.page = 1;
        self.num_per_page = 20;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.agency_name.length > 0)
        {
            [newDic setObject:self.agency_name forKey:@"agency_name"];
        }
    }
    
    return newDic;
}

- (HYRowDataResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAgencyCountResponse *respose = [[HYAgencyCountResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
