//
//  HYGetRedpacketCountReq.m
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGetRedpacketCountReq.h"

@implementation HYGetRedpacketCountReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/red_packet/red_packet_count"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetRedpacketCountResp *respose = [[HYGetRedpacketCountResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYGetRedpacketCountResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        self.count = [GETOBJECTFORKEY(dictionary, @"data", [NSString class]) integerValue];
    }
    
    return self;
}

@end
