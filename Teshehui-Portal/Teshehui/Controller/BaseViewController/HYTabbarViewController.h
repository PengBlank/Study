//
//  CQBaseViewController.h
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

/*
 * 界面框架基础
 */

#import <UIKit/UIKit.h>

#import "HYNavigationController.h"

@interface HYTabbarViewController : UIViewController

- (void)setTabbarShow:(BOOL)show;
- (void)updateTitleView;
- (void)setCurrentSelectIndex:(NSInteger)index;
- (void)setStatus:(BOOL)hasNew atIndex:(NSInteger)index;

@property (nonatomic, strong, readonly) NSArray *viewControllers;

- (void)handleRemoteNotifionInfo;

- (void)umengShake;

- (void)handleLocalNotifcation;

+ (HYTabbarViewController *)sharedTabbarController;

@end
