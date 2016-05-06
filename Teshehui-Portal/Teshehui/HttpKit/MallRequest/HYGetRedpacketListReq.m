//
//  HYGetRebpacketListReq.m
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGetRedpacketListReq.h"

@implementation HYGetRedpacketListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/red_packet/red_packet_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.page]
                   forKey:@"page"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.num_per_page]
                   forKey:@"num_per_page"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetRedpacketListResp *respose = [[HYGetRedpacketListResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYGetRedpacketListResp

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.page = [GETOBJECTFORKEY(data, @"page", [NSString class]) intValue];
        self.total = [GETOBJECTFORKEY(data, @"total", [NSString class]) intValue];
        self.total_page = [GETOBJECTFORKEY(data, @"total_page", [NSString class]) intValue];
        
        self.total_quantity = [GETOBJECTFORKEY(data, @"total_send_quantity", [NSString class]) intValue];
        if (!self.total_quantity) {
            self.total_quantity = [GETOBJECTFORKEY(data, @"total_receive_quantity", [NSString class]) intValue];
        }
        
        self.total_points = [GETOBJECTFORKEY(data, @"total_send_points", [NSString class]) intValue];
        if (!self.total_points) {
            self.total_points = [GETOBJECTFORKEY(data, @"total_receive_points", [NSString class]) intValue];
        }
        
        NSArray *packetsData = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        NSMutableArray *packetsArr = [NSMutableArray array];
        for (NSDictionary *packetData in packetsData)
        {
            HYRedpacketInfo *packet = [[HYRedpacketInfo alloc] initWithDataInfo:packetData];
            [packetsArr addObject:packet];
        }
        self.packetList = [NSArray arrayWithArray:packetsArr];

    }
    
    return self;
}


@end
