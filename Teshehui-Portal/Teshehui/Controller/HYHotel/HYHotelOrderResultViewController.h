//
//  HYHotelOrderResultViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店订单的结果界面
 */

#import "HYHotelViewBaseController.h"

#import "HYHotelInfoDetail.h"
#import "HYHotelOrderBase.h"

@interface HYHotelOrderResultViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYHotelInfoDetail *hotelInfo;
@property (nonatomic, strong) HYHotelOrderBase *hotelOrder;

@end
