//
//  BusinessSearchViewController.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/8.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYLocationManager.h"
@interface BusinessSearchViewController : HYMallViewBaseController
@property (nonatomic,strong) NSString   *cityName;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, assign) NSInteger sort;   //0离我最近 1最新发布
@property (nonatomic,assign) CLLocationCoordinate2D  coor;
@end
