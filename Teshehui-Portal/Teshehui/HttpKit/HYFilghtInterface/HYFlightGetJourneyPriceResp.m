//
//  HYFlightGetJourneyPriceResp.m
//  Teshehui
//
//  Created by HYZB on 14/11/17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightGetJourneyPriceResp.h"

@implementation HYFlightGetJourneyPriceResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *info = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.price = [GETOBJECTFORKEY(info, @"price", [NSString class]) floatValue];
        self.point = [GETOBJECTFORKEY(info, @"points", [NSString class]) floatValue];
    }
    
    return self;
}

@end
