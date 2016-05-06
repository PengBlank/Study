//
//  HYAddPassengerViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 * 添加乘机人界面
 */


#import "HYCustomNavItemViewController.h"
#import "HYPassengerDelegate.h"


@class HYPassengers;

@interface HYAddPassengerViewController : HYCustomNavItemViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id<HYPassengerDelegate> delegate;
@property (nonatomic, assign) PassengerType type;

@end
