//
//  HYFlightOrderDetailViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 机票订单详情
 */

#import "HYFlightBaseViewController.h"
#import "HYFlightOrder.h"

@class HYFlightOrderListViewController;

@interface HYFlightOrderDetailViewController : HYFlightBaseViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYFlightOrder *flightOrder;

@property (nonatomic, weak) HYFlightOrderListViewController *orderListVC;

@end
