//
//  HYAroundCitySelectViewController.h
//  Teshehui
//
//  Created by RayXiang on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
@class HYCityForQRCode;

typedef void(^HYAroundCitySelectBlock)(HYCityForQRCode *city);

@interface HYAroundCitySelectViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) HYAroundCitySelectBlock callback;

@end
