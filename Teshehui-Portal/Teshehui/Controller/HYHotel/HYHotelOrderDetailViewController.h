//
//  HYHotelOrderDetailViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店订单详情的界面
 */

#import "HYHotelViewBaseController.h"
#import "HYHotelOrderDetail.h"

@interface HYHotelOrderDetailViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYHotelOrderDetail *hotelOrder;

@end
