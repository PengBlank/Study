//
//  HYMallOrderListPriceCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@class HYMallOrderSummary;
@class HYMeiWeiQiQiOrderListModel;

@interface HYMallOrderListPriceCell : HYBaseLineCell


@property (nonatomic, strong) UIImageView *indicator;

@property (nonatomic, strong) HYMallOrderSummary *order;
@property (nonatomic, assign) BOOL expand;

@property (nonatomic, strong) HYMeiWeiQiQiOrderListModel *model;

@end
