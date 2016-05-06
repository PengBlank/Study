//
//  HYSignoutRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYSignoutRequest.h"
#import "HYSignoutResponse.h"

@implementation HYSignoutRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/userLogout.action"];
        self.httpMethod = @"POST";
    }
    
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (self.cardNumber)
    {
        [newDic setObject:self.cardNumber
                   forKey:@"cardNumber"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYSignoutResponse *respose = [[HYSignoutResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
