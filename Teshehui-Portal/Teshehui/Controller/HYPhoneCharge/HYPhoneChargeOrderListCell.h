//
//  HYPhoneChargeOrderListCell.h
//  Teshehui
//
//  Created by HYZB on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@class HYPhoneChargeOrderListModel;

typedef NS_ENUM(NSInteger, RechargeType) // 充值类型 2 话费  5 流量
{
    kRechargeTypePhoneNum = 2,
    kRechargeTypedata = 5
};

@protocol HYPhoneChargeOrderListCellDelegate <NSObject>

- (void)cancelBtnAction:(HYPhoneChargeOrderListModel *)model;
- (void)deleteAction:(HYPhoneChargeOrderListModel *)model;
- (void)payAction:(HYPhoneChargeOrderListModel *)model;

@end

@interface HYPhoneChargeOrderListCell : HYBaseLineCell

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) HYPhoneChargeOrderListModel *model;

@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
