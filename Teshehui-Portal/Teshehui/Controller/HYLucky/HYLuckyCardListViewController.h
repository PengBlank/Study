//
//  HYLuckyCardListViewController.h
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//
/*
 *喵喵别人
 */

#import "HYMallViewBaseController.h"
#import "HYLuckyStatusInfo.h"

@interface HYLuckyCardListViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYLuckyStatusInfo *mineCards;

@end
