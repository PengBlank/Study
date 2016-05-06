//
//  HYUpdateCabinPriceRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYUpdateCabinPriceRequest.h"

@implementation HYUpdateCabinPriceRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kFlightRequestBaseURL, @"api/Flight/cabin_price"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.flight_date length] > 0 &&
        [self.org_city length] > 0 &&
        [self.dst_city length] > 0 &&
        [self.cabin_code length] > 0 &&
        [self.flight_no length] > 0)
    {
        [newDic setObject:self.flight_date forKey:@"flight_date"];
        [newDic setObject:self.org_city forKey:@"org_city"];
        [newDic setObject:self.dst_city forKey:@"dst_city"];
        [newDic setObject:self.cabin_code forKey:@"cabin_code"];
        [newDic setObject:self.flight_no forKey:@"flight_no"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYUpdateCabinPriceResponse *respose = [[HYUpdateCabinPriceResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
