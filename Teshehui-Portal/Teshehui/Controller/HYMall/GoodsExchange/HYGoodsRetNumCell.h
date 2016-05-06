//
//  HYGoodsReturnNumberCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetGrayCell.h"

@class HYGoodsRetNumCell;
@protocol hyGoodsRetNumberCellDelegate <NSObject>
@optional
- (void)goodsRetNumberCellDidAddNumber:(HYGoodsRetNumCell *)numberCell;
- (void)goodsRetNumberCellDidMinusNumber:(HYGoodsRetNumCell *)numCell;

@end

@interface HYGoodsRetNumCell : HYGoodsRetGrayCell

@property (nonatomic, strong, readonly) UILabel *numLab;

@property (nonatomic, weak) id<hyGoodsRetNumberCellDelegate> delegate;

@end
