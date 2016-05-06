//
//  HYLuckyWinnerViewController.h
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
/**
 *  @brief  中奖名单
 */
@interface HYLuckyWinnerViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
