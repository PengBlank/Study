//
//  HYSearchUnPromoterCardRequestParam.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSearchUnPromoterCardRequestParam.h"

@implementation HYSearchUnPromoterCardRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_ajax_single_search_card"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.number length] > 0) {
            
            [newDic setObject:self.number forKey:@"number"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYSearchUnPromoterCardResponse *respose = [[HYSearchUnPromoterCardResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
