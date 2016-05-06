//
//  HYUserUpdateInfoReq.m
//  Teshehui
//
//  Created by Kris on 15/9/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUserUpdateInfoReq.h"
#import "HYUserUpdateInfoResponse.h"
#import "HYUserInfo.h"

@implementation HYUserUpdateInfoReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"user/updateUserInfo.action"];
        self.httpMethod = @"POST";
//        self.postType = KeyValue;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        HYUserInfo *userInfo = [HYUserInfo getUserInfo];
        self.userId = userInfo.userId;
        if (self.userId.length > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        if (_nickName.length > 0)
        {
            [newDic setObject:_nickName forKey:@"nickName"];
        }
        if (_email.length)
        {
            [newDic setObject:self.email
                       forKey:@"email"];
        }
        if (_sex.length > 0)
        {
            [newDic setObject:_sex forKey:@"sex"];
        }
    };

    return newDic;
}

- (HYUserUpdateInfoResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYUserUpdateInfoResponse *respose = [[HYUserUpdateInfoResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
