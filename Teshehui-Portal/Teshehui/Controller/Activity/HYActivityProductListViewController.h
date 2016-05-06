//
//  HYActivityProductListViewController.h
//  Teshehui
//
//  Created by HYZB on 14-8-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYActivityGoodsRequest.h"

@interface HYActivityProductListViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYActivityGoodsRequest *getDataReq;

@end
