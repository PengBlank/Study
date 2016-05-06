//
//  CQAppDelegate.h
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTabbarViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface HYAppDelegate : UIResponder
<
UIApplicationDelegate,
UIAlertViewDelegate
>
{
    BMKMapManager* _mapManager;
    
    BOOL _showRemoteLoginAlert;
    
    void (^_loginSuccessCallback)(BOOL success);
}

+ (instancetype)sharedDelegate;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) HYTabbarViewController *baseContentView;

- (void)loadLoginView;
- (void)loadContentView:(BOOL)needUpdate;

- (void)hiddenTabbar;
- (void)loginOther:(BOOL)other;
- (void)showUpGrade;

//- (void)updateLocationinfo;

- (void)logoutFinished;

- (void)chooseRootController;

@property (nonatomic, assign) BOOL isFrom3DTouch;

/// 检测是否登录，如果没登录，就弹出登录框，成功后需继续进行之前的动作
- (void)checkLogin:(void (^)(BOOL success))callback;


@end
