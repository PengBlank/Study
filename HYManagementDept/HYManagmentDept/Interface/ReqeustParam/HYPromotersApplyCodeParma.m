//
//  HYPromotersApplyCodeParma.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromotersApplyCodeParma.h"

@implementation HYPromotersApplyCodeParma

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_apply_code"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPromotersApplyCodeResponse *respose = [[HYPromotersApplyCodeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
