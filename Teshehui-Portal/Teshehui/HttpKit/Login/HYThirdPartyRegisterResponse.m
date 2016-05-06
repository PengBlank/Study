//
//  HYThirdPartyRegisterResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYThirdPartyRegisterResponse.h"

@implementation HYThirdPartyRegisterResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        NSDictionary *loginResultData = GETOBJECTFORKEY(data, @"loginResult", NSDictionary);
        self.loginResult = [[HYLoginResult alloc] initWithDictionary:loginResultData error:nil];
        
        NSDictionary *userdata = GETOBJECTFORKEY(data, @"user", NSDictionary);
        self.userinfo = [[HYUserInfo alloc] initWithDictionary:userdata error:nil];
        self.userinfo.token = self.loginResult.token;
        self.userinfo.userId = self.loginResult.userId;
        
        NSDictionary *thirdData = GETOBJECTFORKEY(data, @"thirdpartyUser", NSDictionary);
        self.thirdpartyUser = [[HYThirdpartyUser alloc] initWithDictionary:thirdData error:nil];
    }
    return self;
}

@end
