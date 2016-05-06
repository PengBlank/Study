//
//  HYPromotersListRequsetParam.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromotersListRequsetParam.h"

@implementation HYPromotersListRequsetParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.promoters length] > 0) {
            
            [newDic setObject:self.promoters forKey:@"promoters"];
        }
        if ([self.code length] > 0) {
            
            [newDic setObject:self.code forKey:@"code"];
        }
        if ([self.start_time length] > 0) {
            
            [newDic setObject:self.start_time forKey:@"start_time"];
        }
        if ([self.end_time length] > 0) {
            
            [newDic setObject:self.end_time forKey:@"end_time"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPromotersListResponse *respose = [[HYPromotersListResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
