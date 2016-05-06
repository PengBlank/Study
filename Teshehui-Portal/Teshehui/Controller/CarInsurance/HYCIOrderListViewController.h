//
//  HYCIOrderListViewController.h
//  Teshehui
//
//  Created by HYZB on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *车险订单列表
 */
#import "HYMallViewBaseController.h"

@interface HYCIOrderListViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

//供支付界面使用，完成后刷新
- (void)reloadOrderData;

@end
