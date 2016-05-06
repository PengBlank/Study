//
//  HYPromotersEarningsRequestParam.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromotersEarningsRequestParam.h"

@implementation HYPromotersEarningsRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_earnings"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPromotersEarningsResponse *respose = [[HYPromotersEarningsResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
