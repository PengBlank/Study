//
//  HYAgencyCardListRequestParam.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyCardListRequestParam.h"

@implementation HYAgencyCardListRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_agency_list_card"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.agency_id length] > 0)
        {
            [newDic setObject:self.agency_id forKey:@"agency_id"];
        }
        
        if ([self.number length] > 0)
        {
            [newDic setObject:self.number forKey:@"number"];
        }
    }
    
    return newDic;
}

- (HYRowDataResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAgencyCardListResponse *respose = [[HYAgencyCardListResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
