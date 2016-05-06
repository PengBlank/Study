//
//  HYBaseHeaderView.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYStrokeField.h"
#import "HYSelectField.h"

@class HYBaseHeaderView;
@protocol HYHeaderViewDelegate <NSObject>

@optional
- (void)headViewDidClickedQueryBtn:(HYBaseHeaderView *)headView;
- (void)headViewDidClickedAllBtn:(HYBaseHeaderView *)headView;

@end

@interface HYBaseHeaderView : UIView

- (UILabel *)getKeyLabel;
- (HYStrokeField *)getField;
- (void)configureBtn:(UIButton *)btn;
- (void)configureSelectBtn:(UIButton *)btn;
- (HYSelectField *)getDateField;

@property (nonatomic, weak) id<HYHeaderViewDelegate> delegate;

@end
