//
//  HYFlightCityVersionResponse.m
//  Teshehui
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightCityVersionResponse.h"

@implementation HYFlightCityVersionResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        CGFloat version = [GETOBJECTFORKEY(data, @"version", NSString) floatValue];
        self.cityVersion = version;
    }
    
    return self;
}

@end
