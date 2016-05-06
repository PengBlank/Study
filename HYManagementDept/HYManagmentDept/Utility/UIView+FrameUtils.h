//
//  UIView+FrameUtils.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-6-12.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameUtils)

- (void)moveToVerticalCenter;

+ (UIView *)wrapperViewWithViews:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

@end
