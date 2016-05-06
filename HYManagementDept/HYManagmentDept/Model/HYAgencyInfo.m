//
//  HYAgencyInfo.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyInfo.h"

@implementation HYAgencyInfo

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.name    = GETOBJECTFORKEY(data, @"name", [NSString class]);
        self.tel   = GETOBJECTFORKEY(data, @"tel", [NSString class]);
        self.address     = GETOBJECTFORKEY(data, @"address", [NSString class]);
        self.bank_account    = GETOBJECTFORKEY(data, @"bank_account", [NSString class]);
        self.payee  = GETOBJECTFORKEY(data, @"payee", [NSString class]);
        self.type  = GETOBJECTFORKEY(data, @"type", [NSString class]);
        self.company_name  = GETOBJECTFORKEY(data, @"company_name", [NSString class]);
        self.m_id = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.bank_name = GETOBJECTFORKEY(data, @"bank_name", [NSString class]);
    }
    
    return self;
}

@end
