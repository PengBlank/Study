//
//  HYGetPersonRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetPersonRequest.h"
#import "HYGetPersonResponse.h"

@implementation HYGetPersonRequest

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

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetPersonResponse *respose = [[HYGetPersonResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
