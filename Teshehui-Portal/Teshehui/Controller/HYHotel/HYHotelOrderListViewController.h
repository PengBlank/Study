//
//  CQHotelOrderViewController.h
//  Teshehui
//
//  Created by ChengQian on 13-11-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYHotelViewBaseController.h"

@interface HYHotelOrderListViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
