//
//  StoreBalanceTableViewCell.h
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreBalanceInfo.h"

typedef void(^sbCellButtonBlock)(StoreBalanceInfo *model, NSInteger buttonTag);

@interface StoreBalanceTableViewCell : UITableViewCell

/**
 刷新UI数据
 */
- (void)refreshUIDataWithModel:(StoreBalanceInfo *)sbInfo WithBlock:(sbCellButtonBlock)block;

//-(void)cellButtonClickBlock:(sbCellButtonBlock)block;

@end
