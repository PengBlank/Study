//
//  HYHotelMainViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 * 酒店的首页
 */
#import "HYHotelViewBaseController.h"

@interface HYHotelMainViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
