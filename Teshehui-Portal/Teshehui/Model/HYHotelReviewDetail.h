//
//  HYHotelReviewDetail.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface HYHotelReviewDetail : NSObject<CQResponseResolve>

@property (nonatomic, assign) CGFloat RatingAll;
@property (nonatomic, assign) CGFloat RatingRoom;
@property (nonatomic, assign) CGFloat RatingPosit;
@property (nonatomic, assign) CGFloat RatingService;
@property (nonatomic, assign) CGFloat RatingCostBenefit;
@property (nonatomic, copy) NSString *UID;
@property (nonatomic, copy) NSString *WritingDate;
@property (nonatomic, copy) NSString *Content;

/*
 Rating : "4.8"	STRING	总分
 RatingRoom	STRING	卫生评分
 RatingPosit	STRING	环境评分
 RatingService	STRING	服务评分
 RatingCostBenefit	STRING	设施评分
 UID	STRING	评分用户
 WritingDate	DATETIME	评价时间
 Content	STRING	内容
 */
@end
