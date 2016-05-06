//
//  HYCategoryCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCategoryInfo.h"
#import "HYBaseLineCell.h"

@interface HYCategoryCell : HYBaseLineCell
{
    UIImageView *_lineView;
}

@property (nonatomic, strong) UIImage *cateImg;

- (void)setWithCategory:(HYMallCategoryInfo *)category;

//- (void)setExpanded:(BOOL)expand;

@end
