//
//  HYGetOrderInfoResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerGetOrderInfoResponse.h"

@implementation HYFlowerGetOrderInfoResponse
- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *result = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        for (id obj in result)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *d = (NSDictionary *)obj;
                self.flowerOrder = [[HYFlowerOrderInfo alloc] initWithDataInfo:d];
            }
        }
    }
    return self;
}

@end
