//
//  HYShareInfoReq.m
//  Teshehui
//
//  Created by HYZB on 15/8/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYShareInfoReq.h"
#import "HYUserInfo.h"

@implementation HYShareInfoReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/help/getExperienceUrl"];
        self.httpMethod = @"POST";
    }
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.price length] > 0)
        {
            [newDic setObject:self.price forKey:@"price"];
        }
        
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if ([userid length] > 0)
        {
            [newDic setObject:userid forKey:@"user_id"];
        }
        
        if ([self.type length] > 0)
        {
            [newDic setObject:self.type forKey:@"type"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYShareInfoResp *respose = [[HYShareInfoResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYShareInfoResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.url = GETOBJECTFORKEY(data, @"url", NSString);
        self.msg = GETOBJECTFORKEY(data, @"msg", NSString);
        self.title = GETOBJECTFORKEY(data, @"title", NSString);
        self.imgurl = GETOBJECTFORKEY(data, @"title_url", NSString);
    }
    
    return self;
}


@end
