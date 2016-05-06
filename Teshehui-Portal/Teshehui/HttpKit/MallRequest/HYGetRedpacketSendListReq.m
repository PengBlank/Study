//
//  HYGetRedpacketSendListReq.m
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGetRedpacketSendListReq.h"

@implementation HYGetRedpacketSendListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/red_packet/send_red_packet_list"];
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
