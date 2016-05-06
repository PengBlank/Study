//
//  HYMallProductListRowCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/14.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYProductListSummary.h"
#import "HYMallProductListCellDelegate.h"

@interface HYMallProductListRowCell : HYBaseLineCell

@property (nonatomic, strong) HYProductListSummary *item;
@property (nonatomic, weak) id<HYMallProductListCellDelegate> delegate;

@end
