//
//  HYNewPassWordRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYNewPassWordRequest.h"
#import "HYNewPassWordResponse.h"

@implementation HYNewPassWordRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/findPasswordSecond.action"];
        self.httpMethod = @"POST";
    }
    
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        if ([self.phone_mob length] > 0)
        {
            [newDic setObject:self.phone_mob forKey:@"mobile"];
        }
        
        if ([self.phone_code length] > 0)
        {
            [newDic setObject:self.phone_code forKey:@"checkCode"];
        }
        
        if ([self.newpassword length] > 0)
        {
            [newDic setObject:self.newpassword forKey:@"newPassword"];
        }
        
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYNewPassWordResponse *respose = [[HYNewPassWordResponse alloc]initWithJsonDictionary:info];
    return respose;
}



@end
