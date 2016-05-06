//
//  HYFlightStockResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/6/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightStockResponse.h"

@implementation HYFlightStockResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *stockInfo = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        NSError *err = nil;
        self.skuStock = [[HYFlightSKUStock alloc] initWithDictionary:stockInfo
                                                               error:&err];
        if (err)
        {
            self.rspDesc = err.domain;
        }
    }
    return self;
}

@end
