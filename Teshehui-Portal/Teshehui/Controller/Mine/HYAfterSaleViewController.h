//
//  HYAfterSaleViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/5/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"
#import "HYMallOrderSummary.h"

//NSString *const kAfterSaleListDidChange;

/**
 *  售后服务
 *  位于, 我的界面, 售后服务
 *
 */
@interface HYAfterSaleViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

//刷新订单列表
- (void)reloadOrderData;

@end
