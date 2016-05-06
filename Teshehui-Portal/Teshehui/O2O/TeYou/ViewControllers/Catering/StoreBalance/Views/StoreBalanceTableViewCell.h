//
//  StoreBalanceTableViewCell.h
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreBalanceInfo.h"

@interface StoreBalanceTableViewCell : UITableViewCell

/**
 充值按钮点击事件
 */
- (void)addPrepayButtonTarget:(id)target Action:(SEL)action Index:(NSInteger)index;
/**
 账单按钮点击事件
 */
- (void)addBillButtonTarget:(id)target Action:(SEL)action Index:(NSInteger)index;

/**
 刷新UI数据
 */
- (void)refreshUIDataWithModel:(StoreBalanceInfo *)sbInfo;

@end
