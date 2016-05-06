//
//  UIBarButtonItem+Common.h
//  Coding_iOS
//
//  Created by ??? on 14/11/5.
//  Copyright (c) 2014年 ???. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)
+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title target:(id)obj action:(SEL)selector;

+ (UIBarButtonItem *)itemWithIcon:(NSString*)iconName showBadge:(BOOL)showbadge target:(id)obj action:(SEL)selector;
@end

