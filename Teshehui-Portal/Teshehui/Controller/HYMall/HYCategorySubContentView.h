//
//  HYCategorySubContentView.h
//  Teshehui
//
//  Created by apple on 15/1/19.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYCategorySubCell;
@interface HYCategorySubContentView : UIView

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, weak) HYCategorySubCell *delegate;

@end
