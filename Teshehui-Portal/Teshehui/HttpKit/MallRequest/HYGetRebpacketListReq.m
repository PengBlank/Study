//
//  HYGetRebpacketListReq.m
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGetRebpacketListReq.h"

@implementation HYGetRebpacketListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kMallRequestBaseURL, @"api/red_packet/red_packet_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:[NSString stringWithFormat:@"%d", self.page]
                   forKey:@"page"];
        [newDic setObject:[NSString stringWithFormat:@"%d", self.num_per_page]
                   forKey:@"num_per_page"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetRebpacketListResp *respose = [[HYGetRebpacketListResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYGetRebpacketListResp

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.page = [GETOBJECTFORKEY(data, @"page", [NSString class]) intValue];
        self.total = [GETOBJECTFORKEY(data, @"total", [NSString class]) intValue];
        self.total_page = [GETOBJECTFORKEY(data, @"total_page", [NSString class]) intValue];
        
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
