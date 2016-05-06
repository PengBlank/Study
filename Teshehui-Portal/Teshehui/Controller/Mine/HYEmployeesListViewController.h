//
//  HYEmployeesListViewController.h
//  Teshehui
//
//  Created by HYZB on 14-7-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 企业员工列表
 */

#import "HYMallViewBaseController.h"

@interface HYEmployeesListViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
