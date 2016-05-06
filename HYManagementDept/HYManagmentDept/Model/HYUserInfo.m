//
//  HYUserInfo.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYUserInfo.h"
#import "NSObject+PropertyListing.h"

@implementation HYUserInfo

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.user_id    = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
        self.user_name   = GETOBJECTFORKEY(data, @"user_name", [NSString class]);
        self.email     = GETOBJECTFORKEY(data, @"email", [NSString class]);
        self.real_name    = GETOBJECTFORKEY(data, @"real_name", [NSString class]);
        self.points  = GETOBJECTFORKEY(data, @"points", [NSString class]);
        self.number  = GETOBJECTFORKEY(data, @"number", [NSString class]);
        self.phone_mob  = GETOBJECTFORKEY(data, @"phone_mob", [NSString class]);
        self.order_pending  = GETOBJECTFORKEY(data, @"order_pending", [NSString class]);
        self.order_shipped  = GETOBJECTFORKEY(data, @"order_shipped", [NSString class]);
        self.order_finished  = GETOBJECTFORKEY(data, @"order_finished", [NSString class]);
        self.order_sum  = GETOBJECTFORKEY(data, @"order_sum", [NSString class]);
        self.is_company = GETOBJECTFORKEY(data, @"is_company", [NSString class]);
        self.is_agency = GETOBJECTFORKEY(data, @"is_agency", [NSString class]);
        self.is_promoters = GETOBJECTFORKEY(data, @"is_promoters", [NSString class]);
        
        NSInteger company = [self.is_company integerValue];
        NSInteger agency = [self.is_agency integerValue];
        NSInteger promoter = [self.is_promoters integerValue];
        if (agency > 0)
        {
            self.organType = OrganTypeAgency;
        }
        else if (company > 0)
        {
            self.organType = OrganTypeCompany;
        }
        else if (promoter > 0)
        {
            self.organType = OrganTypePromoter;
        }
        else
        {
            self.organType = OrganTypeUnkown;
        }
    }
    
    return self;
}

@end
