//
//  HYHotelCitySelectViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCountryInfo.h"
#import "HYHotelCityInfo.h"

#import "HYHotelViewBaseController.h"

@protocol HYCitySelectDelegate;

@interface HYHotelCitySelectViewController : HYHotelViewBaseController
<
UISearchDisplayDelegate,
UISearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, weak) id<HYCitySelectDelegate> delegate;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UISearchDisplayController *searchController;

@end

@protocol HYCitySelectDelegate <NSObject>

@optional
- (void)didSelectCity:(HYCountryInfo *)city;

@end