//
//  HYTaxiGetOrderInfoResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiGetOrderInfoResponse.h"

@implementation HYTaxiGetOrderInfoResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.orderInfo = [[HYTaxiOrder alloc] initWithDictionary:data error:nil];
    }
    return self;
}

@end
