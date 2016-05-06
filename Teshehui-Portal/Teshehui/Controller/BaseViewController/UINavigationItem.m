//
//  UINavigationItem.m
//  ChaoRen
//
//  Created by ichina on 13-12-21.
//  Copyright (c) 2013年 ichina. All rights reserved.
//

#import "UINavigationItem.h"

@implementation UINavigationItem (margin)

//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -20;
    
    if (leftBarButtonItem)
    {
        [self setLeftBarButtonItems:@[spaceButtonItem, leftBarButtonItem]];
    }
    else
    {
        [self setLeftBarButtonItems:@[spaceButtonItem]];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (CheckIOS7)
    {
        spaceButtonItem.width = -10;
    }

    if (rightBarButtonItem)
    {
        [self setRightBarButtonItems:@[spaceButtonItem, rightBarButtonItem]];
    }
    else
    {
        [self setRightBarButtonItems:@[spaceButtonItem]];
    }
}
//#endif

@end
