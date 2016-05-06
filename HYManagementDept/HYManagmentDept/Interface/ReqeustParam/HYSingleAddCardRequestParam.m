//
//  HYSingleAddCardRequestParam.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-19.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSingleAddCardRequestParam.h"

@implementation HYSingleAddCardRequestParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_single_add_card"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.number length] > 0)
        {
            [newDic setObject:self.number forKey:@"number"];
        }
        
        if ([self.agency_id length] > 0) {
            
            [newDic setObject:self.agency_id forKey:@"agency_id"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYSingleAddCardResponse *respose = [[HYSingleAddCardResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
