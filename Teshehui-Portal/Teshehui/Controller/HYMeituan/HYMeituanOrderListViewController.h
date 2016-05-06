//
//  HYMeituanOrderListViewController.h
//  Teshehui
//
//  Created by HYZB on 2014/12/16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCustomNavItemViewController.h"

@interface HYMeituanOrderListViewController : HYCustomNavItemViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
