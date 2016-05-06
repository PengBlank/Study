//
//  HYAgencySummary.m
//  HYManagmentDept
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "HYAgencySummary.h"

@implementation HYAgencySummary

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.name = GETOBJECTFORKEY(dict, @"name", [NSString class]);
        self.month_new_member_count = [GETOBJECTFORKEY(dict, @"month_new_member_count", [NSString class]) floatValue];
        self.member_count = [GETOBJECTFORKEY(dict, @"member_count", [NSString class]) intValue];
        self.clearing_agency = [GETOBJECTFORKEY(dict, @"clearing_agency", [NSString class]) floatValue];
        self.agency_receivable_count = [GETOBJECTFORKEY(dict, @"agency_receivable_count", [NSNumber class]) floatValue];
        self.card_stock = GETOBJECTFORKEY(dict, @"card_stock", [NSString class]);
        self.card_count = GETOBJECTFORKEY(dict, @"card_count", [NSString class]);
        
        NSString *clearing_agency_to_company_profit = [dict objectForKey:@"clearing_agency_to_company_profit"];
        if (clearing_agency_to_company_profit)
        {
            self.clearing_agency_to_company_profit = [clearing_agency_to_company_profit floatValue];
        }
        NSString *clearing_agency_to_company_profit_count = [dict objectForKey:@"clearing_agency_to_company_profit_count"];
        if (clearing_agency_to_company_profit_count)
        {
            self.clearing_agency_to_company_profit_count = [clearing_agency_to_company_profit_count floatValue];
        }
    }
    return self;
}

@end
