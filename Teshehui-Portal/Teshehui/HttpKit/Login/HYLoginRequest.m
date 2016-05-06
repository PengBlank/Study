//
//  CQLgoinRequest.m
//  Teshehui
//
//  Created by ChengQian on 13-11-16.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYLoginRequest.h"
#import "HYLoginResponse.h"

@implementation HYLoginRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/loginUser.action"];//@"http://192.168.0.91:10081/";
        self.httpMethod = @"POST";
    }
    
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.password length] > 0)
        {
            [newDic setObject:self.password forKey:@"password"];
        }
        
        if ([self.loginName length] > 0)
        {
            [newDic setObject:self.loginName forKey:@"loginName"];
        }
        
        if ([self.checkCode length] > 0)
        {
            [newDic setObject:self.checkCode forKey:@"checkCode"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYLoginResponse *respose = [[HYLoginResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
