//
//  HYPayWaysCell.h
//  Teshehui
//
//  Created by Kris on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
@protocol HYPayWaysCellDelegate<NSObject>

@optional
- (void)choosePayment:(UIButton *)sender;

@end

@interface HYPayWaysCell : HYBaseLineCell

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, weak) id<HYPayWaysCellDelegate> delegate;
@property (nonatomic, assign) BOOL isSelected;

@end
