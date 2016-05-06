//
//  HYFlightGetOrderInfoResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightGetOrderInfoResponse.h"

@interface HYFlightGetOrderInfoResponse ()

@property (nonatomic, strong) HYFlightOrder *flightOrder;

@end

@implementation HYFlightGetOrderInfoResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *order = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.flightOrder = [[HYFlightOrder alloc] initWithDictionary:order error:nil];
    }
    
    return self;
}

@end
