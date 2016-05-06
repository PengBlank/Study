//
//  HYCheckChildTicketReqeust.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCheckChildTicketReqeust.h"
#import "HYCheckChildTicketResponse.h"

@implementation HYCheckChildTicketReqeust

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kFlightRequestBaseURL, @"api/Flight/cabin/"];
        self.httpMethod = @"POST";
        self.pass_type = @"CH";
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
        [self.flight_no length] > 0 &&
        [self.pass_type length] > 0)
    {
        [newDic setObject:self.flight_date forKey:@"flight_date"];
        [newDic setObject:self.org_city forKey:@"org_city"];
        [newDic setObject:self.dst_city forKey:@"dst_city"];
        [newDic setObject:self.cabin_code forKey:@"cabin_code"];
        [newDic setObject:self.flight_no forKey:@"flight_no"];
        [newDic setObject:self.pass_type forKey:@"pass_type"];
        [newDic setObject:[NSString stringWithFormat:@"%d", self.source]
                   forKey:@"source"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCheckChildTicketResponse *respose = [[HYCheckChildTicketResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
