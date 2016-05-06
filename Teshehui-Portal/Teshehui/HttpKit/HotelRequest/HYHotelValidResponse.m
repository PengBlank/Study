//
//  HYHotelValidResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelValidResponse.h"

@implementation HYHotelValidResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.totalAmount = [GETOBJECTFORKEY(data, @"totalAmount", [NSString class]) doubleValue];
        self.points = [GETOBJECTFORKEY(data, @"points", NSString) integerValue];
        self.productTypeCode = [GETOBJECTFORKEY(data, @"productTypeCode", [NSString class]) integerValue];
        self.guaranteeAmount = [GETOBJECTFORKEY(data, @"guaranteeAmount", [NSString class]) floatValue];
        self.cancelStartTime = GETOBJECTFORKEY(data, @"cancelStartTime", [NSString class]);
        self.cancelEndTime = GETOBJECTFORKEY(data, @"cancelEndTime", [NSString class]);
        self.guaranteeCurrencyCode = GETOBJECTFORKEY(data, @"guaranteeCurrencyCode", [NSString class]);
        self.guaranteeDescription = GETOBJECTFORKEY(data, @"guaranteeDescription", [NSString class]);
        self.cancelAmount = GETOBJECTFORKEY(data, @"cancelAmount", [NSString class]);
        self.cancelCurrencyCode = GETOBJECTFORKEY(data, @"cancelCurrencyCode", [NSString class]);
    }
    
    return self;
}

@end
