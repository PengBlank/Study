//
//  HYHotelStar.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-13.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelStar.h"

static NSInteger __starMapping[5] = {0, 2, 3, 4, 5};
static NSArray *__starShowMapping = nil;

@implementation HYHotelStar

+ (instancetype)hotelStarWithIndex:(NSInteger)idx
{
    HYHotelStar *star = [[HYHotelStar alloc] init];
    star.index = idx;
    return star;
}

- (NSInteger)star
{
    return __starMapping[_index];
}

+ (NSArray *)starShowMapping
{
    if (!__starShowMapping)
    {
        __starShowMapping = @[@"不限",
                              @"二星以及以下/经济",
                              @"三星级/舒适",
                              @"四星级/高档",
                              @"五星/豪华"
                              ];
    }
    return __starShowMapping;
}

- (NSString *)starDesc
{
    return [[self class] starShowMapping][_index];
}

@end


/*
 array = @[@"不限",
 @"五星级/豪华",
 @"四星级/高档",
 @"三星级/舒适",
 @"二星级以及以下/经济"];
*/