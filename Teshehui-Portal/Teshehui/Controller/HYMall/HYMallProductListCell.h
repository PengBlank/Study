//
//  HYMallProductListCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallProductCellData.h"
#import "HYMallProductListCellDelegate.h"

//用于搜索结果
#import "HYProductListSummary.h"


@interface HYMallProductListCell : HYBaseLineCell

@property (nonatomic, weak) id<HYMallProductListCellDelegate> delegate;

@property (nonatomic, strong) HYMallProductCellData *cellData;

//搜索结果界面显示
- (void)setLeftItem:(HYProductListSummary *)litem rightItem:(HYProductListSummary *)ritem;

@end
