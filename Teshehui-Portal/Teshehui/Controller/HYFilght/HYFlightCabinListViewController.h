//
//  HYFlightCabinListViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-6-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//



#import "HYFlightBaseViewController.h"
#import "HYFlightCity.h"
#import "HYFlightListSummary.h"
#import "HYCabins.h"
/**
 * 机票舱位选择界面
 */
@interface HYFlightCabinListViewController : HYFlightBaseViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, strong) HYFlightListSummary *flightSummary;   //航班信息
@property (nonatomic, assign) CabinType type;

@end
