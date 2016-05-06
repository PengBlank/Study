//
//  HYTaxiAddOrderResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiAddOrderResponse.h"

@implementation HYTaxiAddOrderResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        NSDictionary *order = GETOBJECTFORKEY(data, @"parentOrder", NSDictionary);
        self.order = [[HYTaxiOrder alloc] initWithDictionary:order error:nil];
    }
    return self;
}

@end
