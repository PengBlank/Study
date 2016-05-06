//
//  HYAddPassengerRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAddPassengerRequest.h"

@implementation HYAddPassengerRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/addContact.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.userId length] > 0)
    {
        if ([self.realName length] > 0)
        {
            [newDic setObject:self.realName forKey:@"realName"];
        }
        if ([self.certificateCode length] > 0)
        {
            [newDic setObject:self.certificateCode forKey:@"certificateCode"];
        }
        if ([self.certifacateNumber length] > 0)
        {
            [newDic setObject:self.certifacateNumber forKey:@"certificateNumber"];
        }
        if ([self.sex length] > 0)
        {
            [newDic setObject:self.sex forKey:@"sex"];
        }
//        if ([self.is_adult length] > 0)
//        {
//            [newDic setObject:self.is_adult forKey:@"is_adult"];
//        }
        if (self.phone)
        {
            [newDic setObject:self.phone forKey:@"phone"];
        }
        if ([self.country length] > 0)
        {
            [newDic setObject:self.country forKey:@"country"];
        }
        if ([self.birthday length] > 0)
        {
            [newDic setObject:self.birthday forKey:@"birthday"];
        }
        if ([self.email length] > 0)
        {
            [newDic setObject:self.email forKey:@"email"];
        }
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"添加常用旅客缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPassengerResponse *respose = [[HYPassengerResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
