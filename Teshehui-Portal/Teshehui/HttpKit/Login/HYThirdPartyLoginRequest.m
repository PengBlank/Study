//
//  HYThirdPartyLoginRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYThirdPartyLoginRequest.h"
#import "JSONKit_HY.h"

@implementation HYThirdPartyLoginRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/user/thirdpartyUserLogin.action", kJavaRequestBaseURL];
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
        if (self.thirdpartyType)
        {
            [data setObject:_thirdpartyType forKey:@"thirdpartyType"];
        }
        if (self.thirdpartyToken)
        {
            [data setObject:_thirdpartyToken forKey:@"thirdpartyToken"];
        }
        if (self.thirdpartyOpenid)
        {
            [data setObject:_thirdpartyOpenid forKey:@"thirdpartyOpenId"];
        }
        
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
    HYThirdPartyLoginResponse *respose = [[HYThirdPartyLoginResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
