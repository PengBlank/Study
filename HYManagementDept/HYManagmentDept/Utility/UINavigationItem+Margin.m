//
//  UINavigationItem+Margin.m
//  HYManagmentDept
//
//  Created by apple on 15/4/23.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "UINavigationItem+Margin.h"

@implementation UINavigationItem (Margin)

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1

- (void)setLeftBarButtonItemWithMargin:(UIBarButtonItem *)left
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        
        if (left)
        {
            [self setLeftBarButtonItems:@[negativeSeperator, left]];
        }
        else
        {
            [self setLeftBarButtonItems:@[negativeSeperator]];
        }
    }
    else
    {
        [self setLeftBarButtonItem:left animated:NO];
    }
}

- (void)setRightBarButtonItemWithMargin:(UIBarButtonItem *)right
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -12;
        
        if (right)
        {
            [self setRightBarButtonItems:@[negativeSeperator, right]];
        }
        else
        {
            [self setRightBarButtonItems:@[negativeSeperator]];
        }
    }
    else
    {
        [self setRightBarButtonItem:right animated:NO];
    }
}

#endif

@end
