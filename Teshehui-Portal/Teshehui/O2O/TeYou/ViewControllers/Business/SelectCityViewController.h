//
//  SelectCityViewController.h
//  Teshehui
//
//  Created by apple_administrator on 15/8/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/**
    O2O附近商家选择城市页
 **/

#import "HYMallViewBaseController.h"
#import "CityListRequest.h"
#import "CitySelectInfo.h"

typedef void(^citySelectBlock)(NSString *city);

@interface SelectCityViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) NSString      *currentCity;
@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, copy) citySelectBlock callback;

@property (nonatomic, strong) UISearchBar                 *mySearchBar;
@property (nonatomic, strong) UISearchDisplayController   *mySearchDisplayController;;

@end
