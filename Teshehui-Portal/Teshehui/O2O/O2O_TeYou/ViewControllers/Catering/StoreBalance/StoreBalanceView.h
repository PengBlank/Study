//
//  StoreBalanceView.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/16.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  商家余额页面

#import <UIKit/UIKit.h>
#import "StoreBalanceInfo.h"        // 数据

typedef NS_ENUM(NSInteger, ButtonType)
{
    prepayButtonType    = 0,    // 充值
    billButton          = 1     // 账单
};
typedef NS_ENUM(NSInteger, BalanceType)
{
    Business            = 0,    // 普通商家
    Billiards           = 1     // 桌球商家
};

typedef void(^BalanceListViewBlock)(StoreBalanceInfo* model, BalanceType balanceType, ButtonType type);

@interface StoreBalanceView : UIView

-(id)initWithFrame:(CGRect)frame Type:(NSInteger)type Block:(BalanceListViewBlock)block;

@end
