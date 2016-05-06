//
//  HYHotelListViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *酒店列表界面
 */

#import "HYHotelViewBaseController.h"
#import "HYHotelCityInfo.h"
#import "HYHotelCondition.h"

@interface HYHotelListViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign) BOOL searchNear;  //是否查询附近

//搜索条件
@property (nonatomic, copy) NSString *searchCheckInDate;
@property (nonatomic, copy) NSString *searchCheckOutDate;
@property (nonatomic, strong) HYHotelCondition *condition;



@end
