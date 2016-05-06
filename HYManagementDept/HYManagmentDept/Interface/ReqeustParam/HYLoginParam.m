//
//  HYLoginParam.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYLoginParam.h"

@implementation HYLoginParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/yy_login"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.user_name length] > 0)
        {
            [newDic setObject:self.user_name forKey:@"user_name"];
        }
        
        if ([self.password length] > 0) {
            [newDic setObject:self.password forKey:@"password"];
        }
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYLoginResponse *respose = [[HYLoginResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
