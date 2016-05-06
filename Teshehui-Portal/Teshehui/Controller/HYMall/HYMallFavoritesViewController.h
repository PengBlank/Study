//
//  HYMallFavoritesViewController.h
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/// 收藏列表

#import "HYMallViewBaseController.h"

@interface HYMallFavoritesViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
