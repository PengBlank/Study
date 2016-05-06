//
//  HYModifyPasswordRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYModifyPasswordRequest.h"

@implementation HYModifyPasswordRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/modifyPassword.action"];
        self.httpMethod = @"POST";
    }
    
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {   
        if ([self.password_new length] > 0)
        {
            [newDic setObject:self.password_new forKey:@"newPassword"];
        }
        
        if ([self.password_old length] > 0)
        {
            [newDic setObject:self.password_old forKey:@"oldPassword"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYModifyPasswordRespone *respose = [[HYModifyPasswordRespone alloc]initWithJsonDictionary:info];
    return respose;
}

@end
