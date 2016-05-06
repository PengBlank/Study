//
//  HYBaseDetailViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-15.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSlideDefine.h"



/**
 *  detail界面的统一父类
 */
@interface HYBaseDetailViewController : UIViewController
<
UIGestureRecognizerDelegate
>

@property (nonatomic, strong) UIBarButtonItem *menuItem;


@property (nonatomic, assign) SlideState slideState;
- (void)becomeState:(SlideState)slideState;

/*
 *  Use for unit tests!
 */
@property (nonatomic, assign, readonly) BOOL keyboardIsShow;
- (void)keyboardShow:(NSNotification *)n;
- (void)keyboardHide:(NSNotification *)n;
- (void)menuItemClicked:(UIBarButtonItem *)menuItem;

@end


