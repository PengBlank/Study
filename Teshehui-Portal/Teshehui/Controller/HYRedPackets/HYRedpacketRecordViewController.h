//
//  HYRedpacketRecordViewController.h
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *红包记录
 */

#import "HYMallViewBaseController.h"

@interface HYRedpacketRecordViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
