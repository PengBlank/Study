//
//  HYCategorySubCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCategoryInfo.h"

@protocol HYCategorySubCellDelegate <NSObject>

- (void)didSelectSubCategory:(HYMallCategoryInfo *)category atIndex:(NSInteger)idx;
//- (void)shouldExpandCellAtIndex:(NSInteger)idx;

@end

@interface HYCategorySubCell : UITableViewCell

@property (nonatomic, strong) UIImageView *lineView;

//- (void)setWithCategory:(HYMallBigClassInfo *)category;
@property (nonatomic, strong) HYMallCategoryInfo *category;


//+ (CGFloat)heightForSubcates:(NSArray *)subCates selectedIdx:(NSInteger)idx;

@property (nonatomic, weak) id<HYCategorySubCellDelegate> delegate;
- (void)contentViewDidSelectAtIndex:(NSInteger)idx;

@end
