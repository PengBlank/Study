//
//  HYHotelTraffic.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelTraffic.h"

@implementation HYHotelTraffic

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.HotelID = GETOBJECTFORKEY(data, @"HotelID", [NSString class]);
        self.TypeNameEN = GETOBJECTFORKEY(data, @"TypeNameEN", [NSString class]);
        self.TypeName = GETOBJECTFORKEY(data, @"TypeName", [NSString class]);
        self.PlaceNameEN = GETOBJECTFORKEY(data, @"PlaceNameEN", [NSString class]);
        self.PlaceName = GETOBJECTFORKEY(data, @"PlaceName", [NSString class]);
        self.Distance = GETOBJECTFORKEY(data, @"Distance", [NSString class]);
        self.ArrivalWay = GETOBJECTFORKEY(data, @"ArrivalWay", [NSString class]);
    }
    
    return self;
}

@end
