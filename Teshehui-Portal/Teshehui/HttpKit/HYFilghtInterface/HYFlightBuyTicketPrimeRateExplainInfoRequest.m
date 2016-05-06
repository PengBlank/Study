//
//  HYFlightBuyTicketPrimeRateExplainInfoRequest.m
//  Teshehui
//
//  Created by HYZB on 15/11/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightBuyTicketPrimeRateExplainInfoRequest.h"

@implementation HYFlightBuyTicketPrimeRateExplainInfoRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kMallRequestBaseURL,@"api/default/get_copywriting"];
        self.httpMethod = @"POST";
    }
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic setObject:self.copywriting_key forKey:@"copywriting_key"];
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlightBuyTicketPrimeRateExplainInfoResponse *response = [[HYFlightBuyTicketPrimeRateExplainInfoResponse alloc] initWithJsonDictionary:info];
    return response;
}

@end
