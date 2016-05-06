//
//  HYModiyPsdViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 *修改密码
 */

#import "HYMallViewBaseController.h"

@interface HYModiyPsdViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
