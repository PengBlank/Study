//
//  HYFlowerMainViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-5-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFolwerViewBaseController.h"

/**
 * 鲜花首页
 */
@interface HYFlowerMainViewController : HYFolwerViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
