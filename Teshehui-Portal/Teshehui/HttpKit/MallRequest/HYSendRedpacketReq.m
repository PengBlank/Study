//
//  HYSendRedpacketReq.m
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSendRedpacketReq.h"

@implementation HYSendRedpacketReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/red_packet/red_packet_add"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.total_amount]
                   forKey:@"total_amount"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.packet_type]
                   forKey:@"packet_type"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.packet_low]
                   forKey:@"packet_low"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.packet_high]
                   forKey:@"packet_high"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.packet_avg]
                   forKey:@"packet_avg"];
        
        if (self.luck_quantity)
        {
            [newDic setObject:[NSString stringWithFormat:@"%ld", self.luck_quantity]
                       forKey:@"luck_quantity"];
        }
        
        if (self.type)
        {
            [newDic setObject:[NSString stringWithFormat:@"%ld", self.type]
                       forKey:@"type"];
        }
        
        if (self.greetings)
        {
            [newDic setObject:self.greetings
                       forKey:@"greetings"];
        }
        
        if (self.phone_num)
        {
            [newDic setObject:self.phone_num
                       forKey:@"phone_num"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYSendRedpacketRep *respose = [[HYSendRedpacketRep alloc]initWithJsonDictionary:info];
    return respose;
} 

@end

@implementation HYSendRedpacketRep

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        if ([data isKindOfClass:[NSDictionary class]])
        {
            self.packetInfo = [[HYRedpacketInfo alloc] initWithDataInfo:data];
        }
        else if ([data isKindOfClass:[NSArray class]])
        {
            NSDictionary *realData = [(NSArray *)data objectAtIndex:0];
            self.packetInfo = [[HYRedpacketInfo alloc] initWithDataInfo:realData];
        }
    }
    return self;
}

@end
