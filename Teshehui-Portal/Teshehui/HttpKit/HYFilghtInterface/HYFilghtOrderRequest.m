//
//  HYFilghtOrderRequest.m
//  ComeHere
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFilghtOrderRequest.h"
#import "HYFilghtOrderResponse.h"

@implementation HYFilghtOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://air.teshehui.com/api/Order/new_order";
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.user_id length] > 0 &&
        [self.passengers length] > 0 &&
        [self.passenger_id_cards length] > 0 &&
        [self.cabin_code length] > 0 &&
        [self.flight_no length] > 0 &&
        [self.org_airport length] > 0 &&
        [self.dst_airport length] > 0 &&
        [self.date length] > 0)
    {
        [newDic setObject:self.user_id forKey:@"user_id"];
        [newDic setObject:self.passengers forKey:@"passengers"];
        [newDic setObject:self.passenger_id_cards forKey:@"passenger_id_cards"];
        [newDic setObject:self.user_id forKey:@"user_id"];
        [newDic setObject:self.flight_no forKey:@"flight_no"];
        [newDic setObject:self.org_airport forKey:@"org_airport"];
        [newDic setObject:self.dst_airport forKey:@"dst_airport"];
        [newDic setObject:self.date forKey:@"date"];
        
        if ([self.jounery length] > 0)
        {
            [newDic setObject:self.jounery forKey:@"jounery"];
        }
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"机票查询请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFilghtOrderResponse *respose = [[HYFilghtOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
