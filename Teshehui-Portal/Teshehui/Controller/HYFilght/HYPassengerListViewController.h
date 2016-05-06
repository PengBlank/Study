//
//  HYPassengerListViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCustomNavItemViewController.h"
#import "HYPassengerDelegate.h"
#import "HYFlightBaseViewController.h"
//选择乘机人

//编辑常用旅客
@interface HYPassengerListViewController : HYFlightBaseViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id<HYPassengerDelegate> delegate;
@property (nonatomic, assign) PassengerType type;

@property (nonatomic, assign) NSInteger max;
@property (nonatomic, strong) NSMutableArray *selectPassengers;

@end
