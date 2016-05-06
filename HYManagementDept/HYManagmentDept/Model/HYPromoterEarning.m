//
//  HYEarning.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromoterEarning.h"

@implementation HYPromoterEarning

- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init]) {
        self.real_name = GETOBJECTFORKEY(data, @"real_name", [NSString class]);
        self.receivable = [GETOBJECTFORKEY(data, @"receivable", [NSString class]) floatValue];
        self.clearing_period = GETOBJECTFORKEY(data, @"clearing_period", [NSString class]);
        self.clearing_time = GETOBJECTFORKEY(data, @"clearing_time", [NSString class]);
        
        self.user_id = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
        self.promoters_id = GETOBJECTFORKEY(data, @"promoters_id", [NSString class]);
        self.start_time = GETOBJECTFORKEY(data, @"start_time", [NSString class]);
        self.end_time = GETOBJECTFORKEY(data, @"end_time", [NSString class]);
    }
    
    return self;
}

@end
