//
//  HYHotelInfoDesc.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelInfoDesc.h"

@implementation HYHotelInfoDesc

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super initWithDataInfo:data];
    
    if (self)
    {
        NSDictionary *baseInfo = GETOBJECTFORKEY(data, @"BaseInfo", [NSDictionary class]);
        self.Roomquantity = GETOBJECTFORKEY(baseInfo, @"Roomquantity", [NSString class]);
        self.Brief = GETOBJECTFORKEY(baseInfo, @"Brief", [NSString class]);
        self.HotelDesc = GETOBJECTFORKEY(baseInfo, @"HotelDesc", [NSString class]);
        self.ServiceBrief = GETOBJECTFORKEY(baseInfo, @"ServiceBrief", [NSString class]);
        
        NSMutableArray *services = [[NSMutableArray alloc] init];
        NSArray *array = GETOBJECTFORKEY(data, @"Service", [NSArray class]);
        for (id obj in array)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                HYHotelService *h = [[HYHotelService alloc] initWithDataInfo:obj];
                [services addObject:h];
            }
        }
        
        self.serviceList = services;
        
        NSMutableArray *muTraffic = [[NSMutableArray alloc] init];
        NSArray *traffics = GETOBJECTFORKEY(data, @"Traffic", [NSArray class]);
        for (id obj in traffics)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                HYHotelTraffic *t = [[HYHotelTraffic alloc] initWithDataInfo:obj];
                [muTraffic addObject:t];
            }
        }
        
        self.trafficList = muTraffic;
    }
    
    return self;
}

@end
