//
//  HYFlightOrderViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 机票订单填写界面
 */

#import "HYFlightBaseViewController.h"
#import "HYFlightSummaryView.h"

@class HYFlightSKU;
@class HYFlightCity;
@class HYFlightDetailInfo;

@interface HYFlightFillOrderViewController : HYFlightBaseViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) HYFlightSKU *orgCabin;
@property (nonatomic, strong) HYFlightDetailInfo *flight;
@property (nonatomic, strong) HYFlightListSummary *flightSummary;   //航班信息

@end
