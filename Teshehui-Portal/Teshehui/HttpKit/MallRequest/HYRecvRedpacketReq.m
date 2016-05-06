//
//  HYRecvRedpacketReq.m
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRecvRedpacketReq.h"

@implementation HYRecvRedpacketReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/red_packet/receive_red_packet"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.code)
        {
            [newDic setObject:self.code
                       forKey:@"code"];
        }
        
        if (self.luck_password)
        {
            [newDic setObject:self.luck_password
                       forKey:@"luck_password"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYRecvRedpacketResp *respose = [[HYRecvRedpacketResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYRecvRedpacketResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.packetInfo = [[HYRedpacketInfo alloc] initWithDataInfo:data];
        NSArray *recvItems = GETOBJECTFORKEY(data, @"items", NSArray);
        if (recvItems.count > 0)
        {
            NSDictionary *recvData = [recvItems objectAtIndex:0];
            HYRedpacketRecv *recv = [[HYRedpacketRecv alloc] initWithDataInfo:recvData];
            self.recv = recv;
        }
    }
    return self;
}

@end
