//
//  HYMallOrderListViewController.h
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  商品订单列表界面
 */
#import "HYMallViewBaseController.h"

#import "HYMallOrderSummary.h"

@interface HYMallOrderListViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

/// 初次进入时显示的订单类型，对应filterType
@property (nonatomic, assign) NSInteger showOrderType;

@property (nonatomic, strong, readonly) UITableView *tableView;

- (void)updateWithOrder:(HYMallOrderSummary *)order type:(MallOrderHandleType)type;

//刷新订单列表 
- (void)reloadOrderData;

@end
