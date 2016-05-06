//
//  UIPageViewController+GWPrivateProperty.m
//  Teshehui
//
//  Created by Kris on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "UIPageViewController+GWPrivateProperty.h"
#import <objc/runtime.h>

@implementation UIPageViewController (GWPrivateProperty)
@dynamic scrollable,bounce;

-(BOOL)scrollable
{
    BOOL scrollable = YES;
    for (UIScrollView *scrollView in self.view.subviews)
    {
        scrollable = scrollView.scrollEnabled;
    }
    return scrollable;
}

-(void)setScrollable:(BOOL)scrollable
{
    id UIQueuingScrollView = NSClassFromString(@"_UIQueuingScrollView");
    
    //get all property
//    u_int count;
//    objc_property_t *properties = class_copyPropertyList([UIQueuingScrollView class], &count);
//    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
//    
//    for (int i = 0; i < count ; i++)
//    {
//        const char* propertyName = property_getName(properties[i]);
//        [propertiesArray addObject:[NSString stringWithUTF8String: propertyName]];
//    }
//    
//    free(properties);
    for (UIQueuingScrollView in self.view.subviews)
    {
        if ([UIQueuingScrollView isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scrollView = UIQueuingScrollView;
            scrollView.scrollEnabled = scrollable;
        }
    }
}

-(void)setBounce:(BOOL)bounce
{
    id UIQueuingScrollView = NSClassFromString(@"_UIQueuingScrollView");
    
    for (UIQueuingScrollView in self.view.subviews)
    {
        if ([UIQueuingScrollView isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scrollView = UIQueuingScrollView;
            scrollView.bounces = bounce;
        }
    }
}

@end
