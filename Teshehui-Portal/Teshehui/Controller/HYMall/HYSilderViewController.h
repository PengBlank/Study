//
//  HYSilderViewController.h
//  Teshehui
//
//  Created by HYZB on 15/1/22.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYSilderViewController : UIViewController

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) BOOL isShow;

- (void)panDetected:(UIPanGestureRecognizer *)recoginzer;
- (void)showHideSidebar;
- (void)autoShowHideSidebar;

//- (void)didShow;
- (void)didHide;
- (void)sidebarDidShown;

@end
