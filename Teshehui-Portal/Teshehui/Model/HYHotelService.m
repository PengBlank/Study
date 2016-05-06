//
//  HYHotelService.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelService.h"

@implementation HYHotelService

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.HotelID = GETOBJECTFORKEY(data, @"HotelID", [NSString class]);
        self.Facility = GETOBJECTFORKEY(data, @"Facility", [NSString class]);
        self.FType = GETOBJECTFORKEY(data, @"FType", [NSString class]);
        self.FTypeName = GETOBJECTFORKEY(data, @"FTypeName", [NSString class]);
        self.FacilityName = GETOBJECTFORKEY(data, @"FacilityName", [NSString class]);
        self.FacilityNameEN = GETOBJECTFORKEY(data, @"FacilityNameEN", [NSString class]);
    }
    
    return self;
}

@end
