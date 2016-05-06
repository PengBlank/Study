//
//  UIButton+Common.h
//  Coding_iOS
//
//  Created by ??? on 14-8-5.
//  Copyright (c) 2014年 ???. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "User.h"
typedef NS_ENUM(NSUInteger, TYButtonEdgeInsetsStyle) {
    TYButtonEdgeInsetsStyleTop, // image在上，label在下
    TYButtonEdgeInsetsStyleLeft, // image在左，label在右
    TYButtonEdgeInsetsStyleBottom, // image在下，label在上
    TYButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (Common)
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color;
+ (UIButton *)buttonWithTitle_ForNav:(NSString *)title;
+ (UIButton *)buttonWithUserStyle;
- (void)userNameStyle;
- (void)frameToFitTitle;
- (void)setUserTitle:(NSString *)aUserName;
- (void)setUserTitle:(NSString *)aUserName font:(UIFont *)font maxWidth:(CGFloat)maxWidth;

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(TYButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

//- (void)configFollowBtnWithUser:(User *)curUser fromCell:(BOOL)fromCell;
//+ (UIButton *)btnFollowWithUser:(User *)curUser;
//
//- (void)configPriMsgBtnWithUser:(User *)curUser fromCell:(BOOL)fromCell;
//+ (UIButton *)btnPriMsgWithUser:(User *)curUser;

@end
