//
//  HYHotelDistance.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDistance.h"

static CGFloat __disanceMapping[] = {0, 0.5, 1, 2, 4, 8, 10};

@implementation HYHotelDistance

+ (instancetype)hotelDistanceWithIndex:(NSInteger)index
{
    HYHotelDistance *ret = [[HYHotelDistance alloc] init];
    ret.index = index;
    return ret;
}

+ (NSArray *)hotelDistanceSource
{
    NSMutableArray *ret = [NSMutableArray array];
    for (int i = 0; i < 7; i++)
    {
        HYHotelDistance *distance = [HYHotelDistance hotelDistanceWithIndex:i];
        [ret addObject:distance];
    }
    return ret;
}

- (float)distance
{
    return __disanceMapping[_index];
}

- (void)setIndex:(NSInteger)index
{
    if (index != _index && index > -1 && index < 7)
    {
        _index = index;
    }
}

- (NSString *)distanceDesc
{
    return [[self class] hotelDistanceDescMapping][_index];
}

+ (NSArray *)hotelDistanceDescMapping
{
    return @[@"不限", @"500米内", @"1公里内", @"2公里内", @"4公里内", @"8公里内", @"10公里内"];
}

@end
