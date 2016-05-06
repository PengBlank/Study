//
//  HYPromoterSelectListRequest.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromoterSelectListRequest.h"

@implementation HYPromoterSelectListRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_select_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

/*
- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.pid length] > 0) {
            
            [newDic setObject:self.pid forKey:@"pid"];
        }
        if ([self.user_id length] > 0) {
            
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
        if ([self.verify length] > 0) {
            
            [newDic setObject:self.verify forKey:@"verify"];
        }
    }
    
    return newDic;
}*/

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPromoterSelectListResponse *respose = [[HYPromoterSelectListResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
