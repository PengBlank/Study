//
//  HYEidtPassengerViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCustomNavItemViewController.h"
#import "HYPassengerDelegate.h"
#import "HYFlightBaseViewController.h"

@interface HYEidtPassengerViewController : HYFlightBaseViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id<HYPassengerDelegate> delegate;
@property (nonatomic, assign) PassengerType type;
@property (nonatomic, strong) HYPassengers *passenger;

@end
