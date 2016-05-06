//
//  CQVIPViewController.h
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

/*
 * 我的主界面
 */

#import "HYMallViewBaseController.h"
#import "HYTabbarViewController.h"


@interface HYMineInfoViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) HYTabbarViewController *baseViewController;

- (void)updateWithLoginChange:(NSNotification*)notiy;

- (void)getRedpacketCount;

- (UIViewController *)checkOrderListWithBusiness:(BusinessType)type;

/// 获取共享的视图
+ (HYMineInfoViewController *)sharedMineInfoViewController;

@end
