//
//  BaseCell.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell
@property (nonatomic,strong) CALayer         *topLineLayer;
@property (nonatomic,strong) CALayer         *bottomLineLayer;
@property (nonatomic,strong) CAGradientLayer *shadowLayer;

//@property (nonatomic,strong) BaseInfo        *baseInfo;


- (void)displayTopLine:(BOOL)isShow;
- (void)displayBottomLine:(BOOL)isShow isLast:(BOOL)isLast;
- (void)displayBottomLine:(BOOL)isShow distance:(CGFloat)distance isLast:(BOOL)isLast;
- (void)displayBottomLine:(BOOL)isShow isLast:(BOOL)isLast drawShadow:(BOOL)drawShadow;
- (void)displayBottomLine:(BOOL)isShow distance:(CGFloat)distance isLast:(BOOL)isLast drawShadow:(BOOL)drawShadow;

#pragma mark-- 绑定数据
//- (void)bindData:(BaseInfo *)baseInfo;
@end
