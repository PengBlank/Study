//
//  HYEtAddCardSearchParam.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYEtAddCardSearchParam.h"

@implementation HYEtAddCardSearchParam
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/search_agency_card"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

@end
