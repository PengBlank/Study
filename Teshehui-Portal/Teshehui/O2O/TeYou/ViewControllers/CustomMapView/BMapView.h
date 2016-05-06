//
//  BMapView.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <MapKit/MapKit.h>

@protocol BMapViewDelegate;
@interface BMapView : UIView

@property (nonatomic,strong)    BMKMapView              *BMKMapView;
@property (nonatomic,assign)    double                  span;//default 40000
@property (nonatomic,assign)    CLLocationCoordinate2D  coor;
@property (nonatomic,assign)    BOOL                    isUser;
@property (nonatomic,assign)    BOOL                    isOther;
@property (nonatomic,assign)    BOOL                    isSetMapSpan;
@property (nonatomic,assign)    BOOL                    isRefresh;

- (id)initWithDelegate:(id<BMapViewDelegate>)delegate;
/**
 *  加载大头针数据
 */
- (void)beginLoad;

/**
 *  移除当前显示的大头针
 */
- (void)removeAnnotationView;

/**
 *  设置用户当前位置
 */
- (void)setUserPosition;
///**
// *  刷新地图当前位置
// */
//- (void)reFresh;

/**
 *  放大地图比例
 */
- (void)largenMap;
/**
 *  缩小地图比例
 */
- (void)reduceMap;
@end


@protocol BMapViewDelegate <NSObject>

- (NSInteger)numbersWithCalloutViewForMapView;
- (CLLocationCoordinate2D)coordinateForMapViewWithIndex:(NSInteger)index;
- (UIView *)mapViewCalloutContentViewWithIndex:(NSInteger)index;
- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSInteger)index;

@optional
- (void)calloutViewDidSelectedWithIndex:(NSInteger)index;
-(void)clickMapVieWToLargenView;

@end
