//
//  HYHotelMapViewController.h
//  Teshehui
//
//  Created by RayXiang on 14-6-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHotelViewBaseController.h"
#import "HYHotelInfoDetail.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

typedef enum {
    HYCoorGPS,
    HYCoorGeneral,
    HYCoorBaidu,
} HYMapViewCoorType;

@interface HYHotelMapViewController : HYHotelViewBaseController
<
BMKMapViewDelegate,
UIActionSheetDelegate,
BMKPoiSearchDelegate
>
{
    BMKMapView *_mapView;
    BMKPoiSearch *_searcher;
}

//@property (nonatomic, strong) HYHotelInfoDetail *hotelInfo;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *annotationTitle;
@property (nonatomic, assign) HYMapViewCoorType coorType;

//显示周边信息
@property (nonatomic, assign) BOOL showAroundShops;

@property (nonatomic, assign) BOOL canNavigate;

@end
