//
//  HYGetRedpacketDetailReq.m
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGetRedpacketDetailReq.h"
#import "HYRedpacketRecv.h"

@implementation HYGetRedpacketDetailReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/red_packet/new_red_packet_detail"];
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
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetRedpacketDetailResp *respose = [[HYGetRedpacketDetailResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYGetRedpacketDetailResp

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        HYRedpacketInfo *info = [[HYRedpacketInfo alloc] initWithDataInfo:data];
        self.redpacket = info;
        
        NSArray *recvList = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *data in recvList)
        {
            HYRedpacketRecv *rv = [[HYRedpacketRecv alloc] initWithDataInfo:data];
            [tempArr addObject:rv];
        }
        
        self.recvList = [tempArr copy];
    }
    
    return self;
}


@end
