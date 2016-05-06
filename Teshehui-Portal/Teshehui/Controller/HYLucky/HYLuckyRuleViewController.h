//
//  HYLuckyRuleViewController.h
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYLuckyInfo.h"

/**
 *  游戏规则
 */
@interface HYLuckyRuleViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYLuckyInfo *lukcy;

@end
