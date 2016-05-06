//
//  HYHotelInfoViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店信息
 */

#import "HYHotelViewBaseController.h"
#import "HYHotelInfoDetail.h"

@interface HYHotelInfoViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) HYHotelInfoDetail *hotelInfo;
@property (nonatomic, readonly, strong) UITableView *tableView;

@end
