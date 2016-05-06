//
//  HYMineInfoOrderCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/5/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"

/**
 *  @brief 新版我的界面订单cell
 *  包含 待付款、待发货、待收货、售后服务 四个选项
 */

typedef NS_ENUM(NSInteger, HYMineInfoOrderActionType)
{
    HYMineInfoOrderActionPay,
    HYMineInfoOrderActionSend,
    HYMineInfoOrderActionRecieve,
    HYMineInfoOrderActionAfter,
};

@interface HYMineInfoOrderCell : HYBaseLineCell

@property (nonatomic, copy) void (^orderCellCallback)(HYMineInfoOrderActionType action);

- (void)setCount:(NSInteger)count forType:(HYMineInfoOrderActionType)type;

@end
