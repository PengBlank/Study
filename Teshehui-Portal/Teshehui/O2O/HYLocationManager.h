//
//  HYLocationManager.h
//  Teshehui
//
//  Created by RayXiang on 14-11-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "JSONModel.h"

@class BMKUserLocation;
@class HYLocateResultInfo;

typedef enum {
    HYNotLocate                 = 0,
    HYIsLocating                = 1,
    HYLocateSuccess             = 200,
    HYReverseGeoSearching       = 201,
    HYReverseGeoSearchFailed    = 202,
    HYReverseGeoSearchSuccess   = 203,
    HYLocateFailed              = 100,
    HYLocateDeny                = 101
} HYLocateState;


//addrInfo : kHotelDefCity, kUserAddress, kUserLocation
typedef void(^ReverseGeoSearchCallback)(HYLocateState state, HYLocateResultInfo *addrInfo);
typedef void(^LocateCallback)(HYLocateState state, HYLocateResultInfo *addrInfo);
typedef void(^TraceCallback)(HYLocateState state, BMKUserLocation *location);

@interface HYLocateResultInfo : JSONModel

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *streetName;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;

@end

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

//同步获取缓存位置信息，如果没有则返回nil
- (HYLocateResultInfo *)getCacheAddress;

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
