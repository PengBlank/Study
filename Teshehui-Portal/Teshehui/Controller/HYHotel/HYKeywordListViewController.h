//
//  HYKeywordListViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店搜索关键字商圈或者行政区列表
 */

#import "HYHotelViewBaseController.h"
#import "HYHotelCondition.h"

@interface HYKeywordListViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYHotelCondition *condition;
//@property (nonatomic, assign) SubConditionType condType;

@end
