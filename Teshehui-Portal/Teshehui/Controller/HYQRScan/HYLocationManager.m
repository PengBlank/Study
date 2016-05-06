//
//  HYLocationManager.m
//  Teshehui
//
//  Created by RayXiang on 14-11-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYLocationManager.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HYAppDelegate.h"

#define Use_Baidu 0

const double x_pi = M_PI * 3000.0 / 180.0;

void transform_baidu_from_mars(double bd_lat, double bd_lon, double *gg_lat, double *gg_lon)
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    *gg_lon = z * cos(theta);
    *gg_lat = z * sin(theta);
}


@interface HYLocationManager ()
<CLLocationManagerDelegate,
BMKGeneralDelegate,
BMKLocationServiceDelegate,
BMKGeoCodeSearchDelegate>
{
    CLLocationManager *_locationManager;
    NSMapTable *_locatingTargets;
    NSMapTable *_successTargets;
    NSMapTable *_failedTargets;
    
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geocodesearch;

}

@property (nonatomic, assign) BOOL shouldSendAction;

@property (nonatomic, copy) ReverseGeoSearchCallback geoSearchCallback;
@property (nonatomic, copy) LocateCallback locationCallback;
@property (nonatomic, copy) TraceCallback traceCallback;
@property (nonatomic, copy) LocateCallback systemLocateCallback;

@end

@implementation HYLocationManager

- (instancetype)init
{
    if (self = [super init])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        
        _locatingTargets = [NSMapTable weakToStrongObjectsMapTable];
        _successTargets = [NSMapTable weakToStrongObjectsMapTable];
        _failedTargets = [NSMapTable weakToStrongObjectsMapTable];
        
        _locService = [[BMKLocationService alloc]init];
    }
    return self;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static HYLocationManager *__sharedManager = nil;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[HYLocationManager alloc] init];
    });
    return __sharedManager;
}

- (void)addTarget:(id)target action:(SEL)action state:(HYLocateState)state
{
    if (state == HYIsLocating)
    {
        [_locatingTargets setObject:NSStringFromSelector(action) forKey:target];
    }
    else if (state == HYLocateSuccess)
    {
        [_successTargets setObject:NSStringFromSelector(action) forKey:target];
    }
    else if (state == HYLocateFailed)
    {
        [_failedTargets setObject:NSStringFromSelector(action) forKey:target];
    }
    else
    {
        ///
    }
}

- (void)removeTarget:(id)target state:(HYLocateState)state
{
    if (state == HYIsLocating)
    {
        [_locatingTargets removeObjectForKey:target];
    }
    else if (state == HYLocateSuccess)
    {
        [_successTargets removeObjectForKey:target];
    }
    else if (state == HYLocateFailed)
    {
        [_failedTargets removeObjectForKey:target];
    }
    else
    {
        ///
    }
}

- (void)sendAction
{
    NSMapTable *targets = nil;
    if (_locateState == HYIsLocating)
    {
        targets = _locatingTargets;
    }
    else if (_locateState == HYLocateSuccess)
    {
        targets = _successTargets;
    }
    else if (_locateState == HYLocateFailed)
    {
        targets = _failedTargets;
    }
    
    for (NSObject *target in targets.keyEnumerator.allObjects)
    {
        NSString *action_s = [targets objectForKey:target];
        if (action_s)
        {
            @try {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [target performSelector:NSSelectorFromString(action_s) withObject:self];
#pragma clang diagnostic pop
            }
            @catch (NSException *exception)
            {
                DebugNSLog(@"error: %@", exception.description);
            }
        }
    }
}

#pragma mark -

- (void)startLocate
{
    if ([CLLocationManager locationServicesEnabled]&&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _locService.delegate = self;
        [_locService startUserLocationService];
        
        _locateState = HYIsLocating;
        
        if (_shouldSendAction)
        {
            [self sendAction];
        }
    }
    else
    {
        _locateState = HYLocateFailed;
        if (_shouldSendAction)
        {
            [self sendAction];
        }
        if (_locationCallback)
        {
            _locationCallback(NO, CLLocationCoordinate2DMake(0, 0));
            _locationCallback = nil;
        }
        if (_traceCallback)
        {
            _traceCallback(NO, nil);
            _traceCallback = nil;
        }
    }
}

- (void)locateWithAction
{
    self.shouldSendAction = YES;
    [self startLocate];
}

- (void)locateWithCallback:(LocateCallback)callback
{
    if (callback)
    {
        self.locationCallback = callback;
    }
    self.shouldSendAction = NO;
    
    [self startLocate];
}

- (void)stopLocate
{
    [_locationManager stopUpdatingLocation];
    [_locService stopUserLocationService];
}

//设置位置
- (void)setLocation:(BOOL)success location:(CLLocationCoordinate2D)c
{
    _coor = CLLocationCoordinate2DMake(_coor.latitude, _coor.longitude);
#if !Use_Baidu
    NSDictionary *cooB = BMKConvertBaiduCoorFrom(c, BMK_COORDTYPE_GPS); 
    _coor = BMKCoorDictionaryDecode(cooB);
#endif
    DebugNSLog(@"location : %lf, %lf", c.latitude, c.longitude);
    _locateState = success ? HYLocateSuccess : HYLocateFailed;
    if (_shouldSendAction)
    {
        [self sendAction];
    }
    
    if (_locationCallback)
    {
        _locationCallback(YES, c);
    }
}

#pragma mark - 百度定位


/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    
}


/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _locateState = HYLocateSuccess;
    _coor.latitude = userLocation.location.coordinate.latitude;
    _coor.longitude = userLocation.location.coordinate.longitude;
    
    if (_traceCallback)
    {
        _traceCallback(YES, userLocation);
    }
    if (_locationCallback)
    {
        _locationCallback(YES, userLocation.location.coordinate);
    }
    if (_shouldSendAction)
    {
        [self sendAction];
    }
}


/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    //停止并设置状态
    [self stopLocate];
    self.coor = CLLocationCoordinate2DMake(0, 0);
    _locateState = HYLocateFailed;
    
    //发送事件
    if (_shouldSendAction)
    {
        [self sendAction];
    }
    
    //定位回调
    if (_locationCallback)
    {
        _locationCallback(NO, _coor);
        _locationCallback = nil;
    }
    
    //跟踪回调
    if (_traceCallback)
    {
        _traceCallback(NO, nil);
        _traceCallback = nil;
    }
}

#pragma mark - 反geo搜索
- (void)reverseGeoCode:(CLLocationCoordinate2D)location callback:(ReverseGeoSearchCallback)callback
{
    if (callback)
    {
        self.geoSearchCallback = callback;
    }
    
    
    if (!_geocodesearch)
    {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    }
    
    _geocodesearch.delegate = self;
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        DebugNSLog(@"反geo检索发送成功");
    }
    else
    {
        DebugNSLog(@"反geo检索发送失败");
        _geocodesearch.delegate = nil;
        if (_geoSearchCallback)
        {
            _geoSearchCallback(NO, nil);
        }
        _geoSearchCallback = nil;
    }
}

- (void)getAddressInfo:(ReverseGeoSearchCallback)callback
{
    __weak typeof(self) b_self = self;
    [self locateWithCallback:^(BOOL success, CLLocationCoordinate2D addr)
    {
        [b_self stopLocate];
        if (success)
        {
            [b_self reverseGeoCode:addr callback:callback];
        }
        else
        {
            callback(NO, nil);
        }
    }];
}

- (void)getCacheAddressInfo:(ReverseGeoSearchCallback)callback
{
    NSDictionary *addr = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"addrInfo"];
    if (addr)
    {
        if (callback)
        {
            callback(YES, addr);
        }
    }
    else
    {
        [self getAddressInfo:^(BOOL success, NSDictionary *addrInfo)
        {
            if (success)
            {
                if (callback)
                {
                    callback(success, addrInfo);
                }
                [[NSUserDefaults standardUserDefaults] setObject:addrInfo forKey:@"addrInfo"];
            }
            else
            {
                if (callback)
                {
                    callback(NO, nil);
                }
            }
        }];
    }
}

- (void)clearAddressInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addrInfo"];
}

- (void)registerDefaultInfo
{
    NSNumber *lat = [NSNumber numberWithDouble:0.0];
    NSNumber *lon = [NSNumber numberWithDouble:0.0];
    NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
    
    NSDictionary *defaultD = @{kHotelDefCity:@"深圳",
                               kUserAddress: @"",
                               kUserLocation: userLocation};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultD];
}

#pragma mark - 跟踪
- (void)startTrace:(TraceCallback)callback
{
    if (callback)
    {
        self.traceCallback = callback;
    }
    self.shouldSendAction = NO;
    [self startLocate];
}

- (void)stopTrace
{
    [self stopLocate];
    _traceCallback = nil;
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher
                    result:(BMKGeoCodeResult *)result
                 errorCode:(BMKSearchErrorCode)error
{
    _geocodesearch.delegate = nil;
    if (_geoSearchCallback)
    {
        _geoSearchCallback(NO, nil);
    }
    _geoSearchCallback = nil;
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error
{
    NSString *location = result.address;
    NSString *city = result.addressDetail.city;
    
    if ([city length] > 0)
    {
        //去掉市字，无法在本地数据中检索
        NSString *last = [city substringFromIndex:(city.length-1)];
        if ([last isEqualToString:@"市"])
        {
            city = [city substringToIndex:(city.length-1)];
        }
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:city forKey:kHotelDefCity];
        [def setObject:location forKey:kUserAddress];
        
        CLLocationCoordinate2D userLoc = result.location;
        
        NSNumber *lat = [NSNumber numberWithDouble:userLoc.latitude];
        NSNumber *lon = [NSNumber numberWithDouble:userLoc.longitude];
        NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
        [def setObject:userLocation forKey:kUserLocation];
        [def synchronize];
        
        if (_geoSearchCallback)
        {
            _geoSearchCallback(YES, @{kHotelDefCity:city,
                                      kUserAddress: location,
                                      kUserLocation: userLocation});
        }
        _geoSearchCallback = nil;
        
        //callback
        //        if (_locationCallBack)
        //        {
        //            _locationCallBack(YES, result.location);
        //        }
    }
    
    _geocodesearch.delegate = nil;
    //[self clearLocation];
}

#pragma mark - 系统定位 
- (void)getLocationWithSystem:(LocateCallback)callback
{
    self.systemLocateCallback = callback;
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    [_locationManager startUpdatingLocation];
}

#pragma mark - 系统定位回调
//系统
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    CLLocationCoordinate2D c = newLocation.coordinate;
    if (_systemLocateCallback)
    {
        _systemLocateCallback(YES, c);
    }
    _systemLocateCallback = nil;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D c = currentLocation.coordinate;
    if (_systemLocateCallback)
    {
        _systemLocateCallback(YES, c);
    }
    _systemLocateCallback = nil;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    if (_systemLocateCallback)
    {
        _systemLocateCallback(NO, CLLocationCoordinate2DMake(0, 0));
    }
    _systemLocateCallback = nil;
}

#pragma mark-
- (CLLocationCoordinate2D)getCoorFromBaidu:(CLLocationCoordinate2D)coorBd
{
    double lat = 0.0;
    double lng = 0.0;
    transform_baidu_from_mars(coorBd.latitude, coorBd.longitude, &lat, &lng);
    return CLLocationCoordinate2DMake(lat, lng);
}

@end
