//
//  HYHotelReviewViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店评价界面
 */

#import "HYHotelViewBaseController.h"
#import "HYHotelInfoDetail.h"

@interface HYHotelReviewViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, readonly, strong) UITableView *tableView;
@property (nonatomic, strong) HYHotelInfoDetail *hotelInfo;

@end
