//
//  HYFlightGetJourneyPriceReq.m
//  Teshehui
//
//  Created by HYZB on 14/11/17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightGetJourneyPriceReq.h"

@implementation HYFlightGetJourneyPriceReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kFlightRequestBaseURL,@"api/journey_price"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlightGetJourneyPriceResp *respose = [[HYFlightGetJourneyPriceResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end
