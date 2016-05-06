//
//  HYMallCartCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallCartProduct.h"
#import "HYQuantityControl.h"

@class HYMallCartCell;
@protocol HYMallCartCellDelegate <NSObject>
@optional
- (void)cartCellDidClickDeleteButton:(HYMallCartCell *)cell;
- (void)cartCellDidClickAddButton:(HYMallCartCell *)cell;
- (void)cartCellDidClickMinusButton:(HYMallCartCell *)cell;
- (void)cartCellDidClickCheckButton:(HYMallCartCell *)cell;
- (void)cartCellDidClickEditButton:(HYMallCartCell *)cell;
- (void)cartCell:(HYMallCartCell *)cell didEditQuantity:(NSInteger)quantity;

@end

@interface HYMallCartCell : HYBaseLineCell

@property (nonatomic, assign) BOOL edit;

@property (nonatomic, assign) BOOL navEdit;

@property (nonatomic, strong) HYMallCartProduct *product;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<HYMallCartCellDelegate> delegate;

@property (nonatomic, readonly) HYQuantityControl *quantityControl;
/**
 * cell失效图标是否隐藏
 */
@property (nonatomic, assign, getter=isIconHiden) BOOL iconHiden;

+ (CGFloat)heightForGoods:(HYMallCartProduct *)product withWidth:(CGFloat)width;
- (void)setEdit:(BOOL)edit animated:(BOOL)animated;
- (void)setNavEdit:(BOOL)edit animated:(BOOL)animated;

//导航栏上的编辑
- (void)setViewFromNavButtonWithEditAnimated:(BOOL)animated;

@end
