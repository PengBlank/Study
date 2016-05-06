//
//  HYShareRedpacketReq.m
//  Teshehui
//
//  Created by Charse on 15/12/30.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYShareRedpacketReq.h"

@implementation HYShareRedpacketReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/red_packet/share_red_packet"];
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
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.luck_qunatity]
                   forKey:@"luck_quantity"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.packet_type]
                   forKey:@"packet_type"];
        
        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId forKey:@"user_id"];
        }
        if ([self.greetings length] > 0)
        {
            [newDic setObject:self.greetings forKey:@"greetings"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYShareRedpacketResp *respose = [[HYShareRedpacketResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end

@implementation HYShareRedpacketResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.title = GETOBJECTFORKEY(data, @"title", NSString);
        self.title_url = GETOBJECTFORKEY(data, @"title_url", NSString);
        self.greetings = GETOBJECTFORKEY(data, @"greetings", NSString);
        self.red_packet_url = GETOBJECTFORKEY(data, @"red_packet_url", NSString);
    }
    
    return self;
}

@end