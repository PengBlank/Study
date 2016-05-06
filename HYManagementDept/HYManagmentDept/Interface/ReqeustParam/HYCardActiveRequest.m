//
//  HYCardActiveRequest.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-31.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCardActiveRequest.h"

@implementation HYCardActiveRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/member_card_activate"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
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
        if ([self.phone_mob length] > 0) {
            
            [newDic setObject:self.phone_mob forKey:@"phone_mob"];
        }
        if ([self.password length] > 0) {
            
            [newDic setObject:self.password forKey:@"password"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCardActiveResponse *respose = [[HYCardActiveResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
