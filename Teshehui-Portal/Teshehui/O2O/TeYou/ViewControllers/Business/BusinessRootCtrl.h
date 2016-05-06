//
//  BusinessRootCtrl.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//


/**
    O2O附近商家首页
 **/

#import "HYMallViewBaseController.h"
#import "DownMenuView.h"
#import "HYTabbarViewController.h"
@interface BusinessRootCtrl : HYMallViewBaseController

@property (nonatomic, weak) HYTabbarViewController *baseViewController;

- (void)cityBtnAction:(id)sender;

@property (nonatomic, strong) UISearchBar                 *mySearchBar;
@property (nonatomic, strong) UISearchDisplayController   *mySearchDisplayController;;

@end
