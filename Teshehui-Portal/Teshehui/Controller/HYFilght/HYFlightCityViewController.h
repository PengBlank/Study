//
//  CQCitySelectViewController.h
//  Teshehui
//
//  Created by ChengQian on 13-10-28.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYFlightBaseViewController.h"
#import "HYFlightCity.h"

@protocol HYFlightCityViewControllerDelegate <NSObject>

@optional
- (void)didSelectCity:(HYCountryInfo *)city;

@end
/**
 * 标题名字
 */
typedef NS_ENUM(NSUInteger, TitleName)
{
    City = 1,
    Country = 2,
};

/**
 *  城市选择类型，选择城市或者国家
 */
typedef enum _CityDataSourceType
{
    FlightCity = 1,
    FlightCountry = 2
}CityDataSourceType;

/**
 *  城市选择界面
 */
@interface HYFlightCityViewController : HYFlightBaseViewController
<
UISearchDisplayDelegate,
UISearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, assign) CityDataSourceType dataSoucreType;
@property (nonatomic, assign) id<HYFlightCityViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UISearchDisplayController *searchController;

@property (nonatomic, assign) TitleName titleName;

@end
