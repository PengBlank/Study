//
//  HYFlightBuyTicketPrimeRateExplainInfoResponse.m
//  Teshehui
//
//  Created by HYZB on 15/11/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightBuyTicketPrimeRateExplainInfoResponse.h"

@implementation HYFlightBuyTicketPrimeRateExplainInfoResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        self.air_tips = data[@"air_tips"];
    }
    
    return self;
}


@end
