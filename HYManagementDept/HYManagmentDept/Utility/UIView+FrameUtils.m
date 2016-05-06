//
//  UIView+FrameUtils.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-6-12.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "UIView+FrameUtils.h"

@implementation UIView (FrameUtils)

- (void)moveToVerticalCenter
{
    UIView *superView = self.superview;
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetHeight(superView.frame) / 2 - frame.size.height / 2;
    self.frame = frame;
}

+ (UIView *)wrapperViewWithViews:(id)firstObj, ...
{
    //
    return nil;
}

@end
