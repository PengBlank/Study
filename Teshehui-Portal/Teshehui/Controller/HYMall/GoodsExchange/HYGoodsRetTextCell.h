//
//  HYGoodsRetDescCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetGrayCell.h"

/**
 *  标准高度125 + 20
 */

@class HYGoodsRetTextCell;
@protocol HYGoodsRetDescCellDelegate <NSObject>
@optional
- (void)descCell:(HYGoodsRetTextCell *)cell didGetText:(NSString *)txt;

@end

@interface HYGoodsRetTextCell : HYGoodsRetGrayCell

@property (nonatomic, weak) id<HYGoodsRetDescCellDelegate> delegate;
@property (nonatomic, strong) NSString *descTxt;

@end
