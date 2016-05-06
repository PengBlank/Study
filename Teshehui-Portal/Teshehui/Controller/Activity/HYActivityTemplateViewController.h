//
//  HYActivityTemplateViewController.h
//  Teshehui
//
//  Created by HYZB on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYNavigationController.h"
#import "HYMallViewBaseController.h"
#import "HYGetActivityListRequest.h"

@interface HYActivityTemplateViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYGetActivityListRequest *getDataReq;

@end
