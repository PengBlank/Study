//
//  HYIndemnityProgressViewController.h
//  Teshehui
//
//  Created by Fei Wang on 15-3-31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 * 赔款进度
 */

#import "HYMallViewBaseController.h"

@class HYMallOrderItem;

@interface HYIndemnityProgressViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYMallOrderItem *goodsInfo;

@end
