//
//  HYExuserLoginRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExuserLoginRequest.h"
#import "JSONKit_HY.h"

@implementation HYExuserLoginRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/user/experienceUserLogin.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        if (self.ip)
        {
            self.ip = @"192.168.0.133";
            [data setObject:_ip forKey:@"ip"];
        }
        if (self.checkCode)
        {
            [data setObject:_checkCode forKey:@"checkCode"];
        }
        if (self.mobilePhone)
        {
            [data setObject:_mobilePhone forKey:@"mobilephone"];
        }
        if (self.invitationCode)
        {
            [data setObject:_invitationCode forKey:@"invitationCode"];
        }
        if (self.promotersUserId)
        {
            [data setObject:_promotersUserId forKey:@"promotersUserId"];
        }
        if (self.agencyId)
        {
            [data setObject:_agencyId forKey:@"agencyId"];
        }
        [data setObject:@(_loginFlag) forKey:@"loginFlag"];
        
        NSString *datajson = [data JSONString];
        if (datajson.length > 0)
        {
            [newDic setObject:datajson forKey:@"data"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYExuserLoginResponse *respose = [[HYExuserLoginResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
