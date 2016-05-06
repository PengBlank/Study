//
//  HYAgencyIncomeInfo.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyIncomeInfo.h"

@implementation HYAgencyIncomeInfo

- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init]) {
        self.agency_name = GETOBJECTFORKEY(data, @"name", [NSString class]);
        self.clearing_time = GETOBJECTFORKEY(data, @"clearing_time", [NSString class]);
        self.start_time = GETOBJECTFORKEY(data, @"start_time", [NSString class]);
        self.end_time = GETOBJECTFORKEY(data, @"end_time", [NSString class]);
        self.receivable = [GETOBJECTFORKEY(data, @"receivable", [NSString class]) floatValue] ;
        self.clearing_time = GETOBJECTFORKEY(data, @"clearing_time", [NSString class]);
        self.clearing_period = GETOBJECTFORKEY(data, @"clearing_period", [NSString class]);
        self.m_id = GETOBJECTFORKEY(data, @"ids", [NSString class]);
    }
    
    return self;
}

@end
