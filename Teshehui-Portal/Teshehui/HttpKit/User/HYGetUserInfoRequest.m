//
//  HYGetPersonRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetUserInfoRequest.h"
#import "HYGetPersonResponse.h"

@implementation HYGetUserInfoRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/queryUserInfo.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.userId length] > 0) {
            [newDic setObject:self.userId forKey:@"userId"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetPersonResponse *respose = [[HYGetPersonResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
