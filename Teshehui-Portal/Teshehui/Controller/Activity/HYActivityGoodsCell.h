//
//  HYActivityGoodsCell.h
//  Teshehui
//
//  Created by RayXiang on 14-8-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//
#import "HYBaseLineCell.h"
#import "HYStrikeThroughLabel.h"
#import "HYActivityGoods.h"

@interface HYActivityGoodsCell : HYBaseLineCell

@property (nonatomic, strong) UIImageView* headImg;
@property (nonatomic, strong) UILabel* nameLab;
@property (nonatomic, strong) UILabel* pointLab;
@property (nonatomic, strong) HYStrikeThroughLabel *marketPriceLbl;  //网络指导价
@property (nonatomic, strong) UILabel *activityPriceLbl;//活动价
@property (nonatomic, strong) UILabel *discountLab;

//- (void)setWithGoods:(HYActivityGoods *)goods;
@property (nonatomic, strong) HYActivityGoods *goods;

@end
