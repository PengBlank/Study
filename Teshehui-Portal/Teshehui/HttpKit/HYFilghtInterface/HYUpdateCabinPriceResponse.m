//
//  HYUpdateCabinPriceResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYUpdateCabinPriceResponse.h"

@implementation HYUpdateCabinPriceResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.price = [GETOBJECTFORKEY(data, @"price", [NSString class]) floatValue];
        self.points = [GETOBJECTFORKEY(data, @"points", [NSString class]) floatValue];
        self.support_journey = [GETOBJECTFORKEY(data, @"support_journey", [NSString class]) boolValue];
    }
    
    return self;
}

@end
