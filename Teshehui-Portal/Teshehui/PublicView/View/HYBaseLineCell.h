//
//  HYBaseLineCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYBaseLineCell : UITableViewCell

@property (nonatomic, assign) BOOL hiddenLine;  //隐藏线， 默认NO
@property (nonatomic, assign) CGFloat separatorLeftInset;  //间距右边的距离，主要是为了适配IOS7以及以下, 默认16个px
//@property (nonatomic, assign) BOOL doubleLine;  //上下都需要线  默认NO

// @property (nonatomic, strong) UILabel *certifacateLab;

@end
