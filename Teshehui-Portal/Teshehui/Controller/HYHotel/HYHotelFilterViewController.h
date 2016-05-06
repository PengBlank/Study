//
//  HYHotelFilterViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店筛选条件列表界面
 */

#import "HYHotelViewBaseController.h"
#import "HYHotelCondition.h"

@protocol HYHotelFilterViewControllerDelegate <NSObject>

@optional
- (void)searchConditionDidChange;

@end

@interface HYHotelFilterViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, weak) id<HYHotelFilterViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYHotelCondition *condition;

@end
