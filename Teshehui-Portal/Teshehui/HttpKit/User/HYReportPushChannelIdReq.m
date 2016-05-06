//
//  HYReportPushChannelId.m
//  Teshehui
//
//  Created by HYZB on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYReportPushChannelIdReq.h"

@implementation HYReportPushChannelIdReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kMallRequestBaseURL, @"api/users/get_push_channelid"];
        self.httpMethod = @"POST";
        self.channelid_type = @"2";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:self.userId forKey:@"user_id"];
        
        if (self.channelid)
        {
            [newDic setObject:self.channelid
                       forKey:@"channelid"];
        }
        
        if ([self.channelid_type length] > 0)
        {
            [newDic setObject:self.channelid_type forKey:@"channelid_type"];
        }
        
        if ([self.user_id length] > 0)
        {
            [newDic setObject:self.user_id forKey:@"user_id"];
        }
        
        if (self.baidu_user_id)
        {
            [newDic setObject:self.baidu_user_id
                       forKey:@"baidu_user_id"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQBaseResponse *respose = [[CQBaseResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
