//
//  HYHotelStar.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-13.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYHotelStar : NSObject

+ (instancetype)hotelStarWithIndex:(NSInteger)idx;

@property (nonatomic, copy) NSString *starDesc;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, assign) NSInteger index;
+ (NSArray *)starShowMapping;

@end
