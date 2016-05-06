//
//  HYMineCardViewController.h
//  Teshehui
//
//  Created by HYZB on 14-10-9.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 个人名片
 */

#import "HYMallViewBaseController.h"
#import "HYTabbarViewController.h"

@interface HYMineCardViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) HYTabbarViewController *baseViewController;

@end
