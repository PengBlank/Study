//
//  HYAccountBalanceCell.h
//  Teshehui
//
//  Created by Kris on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYUserCashAccountInfo.h"
//@protocol HYAccountBalanceCellDelegate<NSObject>
//
//- (void)useAccountBalance:(UIButton *)sender;
//
//@end

@interface HYPayAccountBalanceCell : HYBaseLineCell

@property (nonatomic, strong) UIButton *rightBtn;
//@property (nonatomic, weak) id<HYAccountBalanceCellDelegate> delegate;
@property (nonatomic, strong) HYUserCashAccountInfo *data;

//-(void)setIsSelected;
@property (nonatomic, assign) BOOL isSelected;
//- (void)setData:(HYUserCashAccountInfo *)data;

@end
