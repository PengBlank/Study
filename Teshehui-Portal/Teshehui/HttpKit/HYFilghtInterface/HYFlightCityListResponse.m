//
//  HYFlightCityListResponse.m
//  Teshehui
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightCityListResponse.h"
#import "HYFlightCity.h"

@implementation HYFlightCityListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *datalist = GETOBJECTFORKEY(dictionary, @"data", NSArray);
        NSMutableArray *citylist = [NSMutableArray array];
        for (NSDictionary *data in datalist)
        {
            HYFlightCity *city = [[HYFlightCity alloc] initWithJSON:data];
            [citylist addObject:city];
        }
        self.cityList = [citylist copy];
        self.cityListJson = datalist;
    }
    return self;
}

@end
