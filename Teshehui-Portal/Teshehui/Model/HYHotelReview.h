//
//  HYHotelReview.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店评价对象
 */

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"


@interface HYHotelReview : NSObject<CQResponseResolve>

@property (nonatomic, assign) CGFloat RatingAll;
@property (nonatomic, assign) CGFloat RatingRoom;
@property (nonatomic, assign) CGFloat RatingPosit;
@property (nonatomic, assign) CGFloat RatingService;
@property (nonatomic, assign) CGFloat RatingCostBenefit;
@property (nonatomic, assign) NSInteger ratingCount;

@end

/*
 RatingAll	STRING	总体评分
 RatingRoom	STRING	卫生评分
 RatingPosit	STRING	环境评分
 RatingService	STRING	服务评分
 RatingCostBenefit	STRING	设施评分
 ratingCount	STRING	总评价数
 */