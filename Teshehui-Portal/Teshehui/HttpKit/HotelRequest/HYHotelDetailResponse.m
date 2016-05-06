//
//  HYHotelDetailResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDetailResponse.h"

@interface HYHotelDetailResponse ()

@property (nonatomic, strong) HYHotelInfoDetail *hotelDetail;  //点选的半径

@end


@implementation HYHotelDetailResponse
- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        if (data)
        {
            self.hotelDetail = [[HYHotelInfoDetail alloc] initWithDataInfo:data];
        }
    }
    
    return self;
}
@end
