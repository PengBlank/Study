//
//  HYKeywordSettingViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店搜索关键字设置界面
 */

#import "HYHotelViewBaseController.h"
#import "HYHotelCondition.h"

@interface HYKeywordSettingViewController : HYHotelViewBaseController
<
UISearchDisplayDelegate,
UISearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UISearchDisplayController *searchController;

@property (nonatomic, strong) HYHotelCondition *condition;

@end
