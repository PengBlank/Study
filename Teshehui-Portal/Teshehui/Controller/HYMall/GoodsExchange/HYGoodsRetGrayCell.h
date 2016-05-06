//
//  HYGoodsRetGrayCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIViewAutoresizingVerticlCenter UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin

@interface HYGoodsRetGrayCell : UITableViewCell

//灰色圆角背景，isGray为yes时显示，高度始终为40
@property (nonatomic, strong) UIView *grayView;

//红色小星，标识是否必填，nessary为yes时显示
@property (nonatomic, strong) UIImageView *nessaryImage;

@property (nonatomic, strong) UILabel *keyLab;
@property (nonatomic, strong) UILabel *valueLab;

//可点击标识,selectable为yes时显示
@property (nonatomic, strong) UIImageView *indicator;

//必须，有红星
@property (nonatomic, assign) BOOL nessary;
@property (nonatomic, assign) BOOL isGray;
@property (nonatomic, assign) BOOL selectable;

@end
