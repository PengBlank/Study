//
//  BusinessSearchResultController.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/8.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYLocationManager.h"
@interface BusinessSearchResultController : HYMallViewBaseController
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString       *placeholderText;
@property (nonatomic,strong) NSString       *searchKey;
@property (nonatomic,strong) NSString   *cityName;
@property (nonatomic,assign) CLLocationCoordinate2D  coor;
@end
