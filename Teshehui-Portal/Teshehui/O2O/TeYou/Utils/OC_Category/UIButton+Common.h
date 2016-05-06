//
//  UIButton+Common.h
//  Coding_iOS
//
//  Created by ??? on 14-8-5.
//  Copyright (c) 2014年 ???. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "User.h"

@interface UIButton (Common)
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color;
+ (UIButton *)buttonWithTitle_ForNav:(NSString *)title;
+ (UIButton *)buttonWithUserStyle;
- (void)userNameStyle;
- (void)frameToFitTitle;
- (void)setUserTitle:(NSString *)aUserName;
- (void)setUserTitle:(NSString *)aUserName font:(UIFont *)font maxWidth:(CGFloat)maxWidth;

//- (void)configFollowBtnWithUser:(User *)curUser fromCell:(BOOL)fromCell;
//+ (UIButton *)btnFollowWithUser:(User *)curUser;
//
//- (void)configPriMsgBtnWithUser:(User *)curUser fromCell:(BOOL)fromCell;
//+ (UIButton *)btnPriMsgWithUser:(User *)curUser;

@end
