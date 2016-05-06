//
//  HYFlightOrderListViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-3.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 机票订单列表
 */
#import "HYFlightBaseViewController.h"

@class HYFlightOrder;

@interface HYFlightOrderListViewController : HYFlightBaseViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

- (void)deleteOrder:(HYFlightOrder *)order;
- (void)cancelOrder:(HYFlightOrder *)order;

@end
