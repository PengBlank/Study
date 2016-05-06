//
//  HYAppDelegate.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-4.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLoginViewController.h"
#import "HYSplitViewController.h"
#import "WXApi.h"

@interface HYAppDelegate : UIResponder
<UIApplicationDelegate,
UIAlertViewDelegate,
WXApiDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) HYSplitViewController *splitViewController;
@property (nonatomic, strong) HYLoginViewController *loginViewController;

- (void)showLogin;
- (void)showContent;

- (void)handleOtherLogined;
- (void)handleNotPromoters;

@end
