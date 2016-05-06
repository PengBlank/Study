//
//  HYFlightSearchViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 * 机票查询界面
 */

#import "HYFlightBaseViewController.h"

@interface HYFlightSearchViewController : HYFlightBaseViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;


@end
