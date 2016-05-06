//
//  HYLocationManager.h
//  Teshehui
//
//  Created by RayXiang on 14-11-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class BMKUserLocation;

typedef enum {
    HYNotLocate,
    HYIsLocating,
    HYLocateSuccess,
    HYLocateFailed
} HYLocateState;


//addrInfo : kHotelDefCity, kUserAddress, kUserLocation
typedef void(^ReverseGeoSearchCallback)(BOOL success,NSDictionary *addrInfo);
typedef void(^LocateCallback)(BOOL success,CLLocationCoordinate2D addr);
typedef void(^TraceCallback)(BOOL success,BMKUserLocation *location);

@interface HYLocationManager : NSObject

+ (instancetype)sharedManager;

//状态信息
@property (nonatomic, assign) HYLocateState locateState;
@property (nonatomic, assign) CLLocationCoordinate2D coor;

//定位----------------------------
//定位成功后不会终止，需要调用代码手动停止
- (void)locateWithAction;   //定位并发送定位事件
- (void)locateWithCallback:(LocateCallback)callback;    //使用回调
- (void)stopLocate; //停止

//定位事件添加
- (void)addTarget:(id)target action:(SEL)action state:(HYLocateState)state;
- (void)removeTarget:(id)target state:(HYLocateState)state;

//----------------------------


//反geo搜索
- (void)reverseGeoCode:(CLLocationCoordinate2D)location
              callback:(ReverseGeoSearchCallback)callback;

//获取位置信息-----------------
//addrInfo : kHotelDefCity, kUserAddress, kUserLocation: lat:number, long:number
//不带缓存，直接定位
- (void)getAddressInfo:(ReverseGeoSearchCallback)callback;
//先获取缓存，没有则定位
- (void)getCacheAddressInfo:(ReverseGeoSearchCallback)callback;
//清除缓存地址信息
- (void)clearAddressInfo;
- (void)registerDefaultInfo;
//----------------------------------

//跟踪定位,地图位置跟踪专用
- (void)startTrace:(TraceCallback)callback;
- (void)stopTrace;

//使用系统定位
- (void)getLocationWithSystem:(LocateCallback)callback;

//百度坐标转换
- (CLLocationCoordinate2D)getCoorFromBaidu:(CLLocationCoordinate2D)coorBd;

@end
