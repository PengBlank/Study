//
//  HYPromotersVerifyCodeRequest.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-1.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromotersVerifyCodeRequest.h"

@implementation HYPromotersVerifyCodeRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_send_verify_code"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

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
        if ([self.number length] > 0) {
            
            [newDic setObject:self.number forKey:@"number"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPromotersVerifyCodeResponse *respose = [[HYPromotersVerifyCodeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
