//
//  HYHotelDistance.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYHotelDistance : NSObject

+ (instancetype)hotelDistanceWithIndex:(NSInteger)index;
+ (NSArray *)hotelDistanceSource;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *distanceDesc;
@property (nonatomic, assign) float distance;

@end
