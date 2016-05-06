//
//  HYAgencyOrderListRequestParam.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyOrderListRequestParam.h"

@implementation HYAgencyOrderListRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_order_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.start_time length] > 0)
        {
            [newDic setObject:self.start_time forKey:@"start_time"];
        }
        
        if ([self.end_time length] > 0)
        {
            [newDic setObject:self.end_time forKey:@"end_time"];
        }
        
        if ([self.company_id length] > 0)
        {
            [newDic setObject:self.company_id forKey:@"company_id"];
        }
        
        if ([self.agency_id length] > 0)
        {
            [newDic setObject:self.agency_id forKey:@"agency_id"];
        }
        if ([self.promoters_id length] > 0)
        {
            [newDic setObject:self.promoters_id forKey:@"promoters_id"];
        }
        if ([self.user_id length] > 0)
        {
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
        if (self.promoters.length > 0) {
            [newDic setObject:self.promoters forKey:@"promoters"];
        }
        if (self.order_no.length > 0) {
            [newDic setObject:self.order_no forKey:@"order_no"];
        }
        
        [newDic setObject:[NSString stringWithFormat:@"%d", self.type]
                   forKey:@"type"];
    }
    
    return newDic;
}

- (HYRowDataResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAgencyOrderListResponse *respose = [[HYAgencyOrderListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
