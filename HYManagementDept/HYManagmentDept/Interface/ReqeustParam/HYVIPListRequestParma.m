//
//  HYVIPListRequestParma.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYVIPListRequestParma.h"
#import "NSDate+Addition.h"

@implementation HYVIPListRequestParma

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_member_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.number.length > 0) {
            [newDic setObject:self.number forKey:@"number"];
        }
        if (self.user_name.length > 0)
        {
            [newDic setObject:self.user_name forKey:@"user_name"];
        }
        if (_promoters.length > 0)
        {
            [newDic setObject:_promoters forKey:@"promoters_name"];
        }
        if (_fromdate)
        {
            NSString *date = [_fromdate timeIntervalSince1970String];
            [newDic setObject:date forKey:@"start_time"];
        }
        if (_todate)
        {
            NSString *date = [_todate timeIntervalSince1970String];
            [newDic setObject:date forKey:@"end_time"];
        }
    }
    
    return newDic;
}

- (HYRowDataResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYVIPListResponse *respose = [[HYVIPListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
