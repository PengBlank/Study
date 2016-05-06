//
//  HYMallLogisticsTrackViewController.h
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  物流跟踪
 */
#import "HYMallViewBaseController.h"

@interface HYMallLogisticsTrackViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, copy) NSString *orderCode;

@end
