//
//  HYAllCategoryView.h
//  Teshehui
//
//  Created by Kris on 15/6/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYAllCategoryView : UIView
{
    UIView *_backgroundView;
    UIView *_backgroundNavView;
}
@property (nonatomic, strong) UITableView *allCategorySelectTableView;
@property (nonatomic, strong) UITableView *allCategoryTableView;
@property (nonatomic, strong) UITableView *smartSortTableView;


- (void)showWithAnimation:(BOOL)animation andFrame:(CGRect)frame;
- (void)dismissWithAnimation:(BOOL)animation;
@end
