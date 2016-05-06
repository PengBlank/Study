//
//  HYLocationManager.m
//  Teshehui
//
//  Created by RayXiang on 14-11-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYLocationManager.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
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
        _locateState = HYLocateDeny;
        if (_shouldSendAction)
        {
            [self sendAction];
        }
        if (_locationCallback)
        {
            _locationCallback(_locateState, nil);
            _locationCallback = nil;
        }
        if (_traceCallback)
        {
            _traceCallback(_locateState, nil);
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
    _locService.delegate = nil;
    [_locService stopUserLocationService];
    
    [_locationManager stopUpdatingLocation];
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
        HYLocateResultInfo *result = [[HYLocateResultInfo alloc] init];
        result.lat = c.latitude;
        result.lon = c.longitude;
        _locationCallback(_locateState, result);
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
        _traceCallback(_locateState, userLocation);
    }
    if (_locationCallback)
    {
        HYLocateResultInfo *result = [[HYLocateResultInfo alloc] init];
        result.lat = userLocation.location.coordinate.latitude;
        result.lon = userLocation.location.coordinate.longitude;
        _locationCallback(_locateState, result);
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
        HYLocateResultInfo *result = [[HYLocateResultInfo alloc] init];
        result.lat = _coor.latitude;
        result.lon = _coor.longitude;
        _locationCallback(_locateState, result);
        _locationCallback = nil;
    }
    
    //跟踪回调
    if (_traceCallback)
    {
        _traceCallback(_locateState, nil);
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
        _locateState = HYReverseGeoSearching;
    }
    else
    {
        DebugNSLog(@"反geo检索发送失败");
        _locateState = HYReverseGeoSearchFailed;
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
    [self locateWithCallback:^(HYLocateState state, HYLocateResultInfo *addrInfo)
    {
        [b_self stopLocate];
        if (state == HYLocateSuccess)
        {
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = addrInfo.lat;
            coordinate.longitude = addrInfo.lon;
            [b_self reverseGeoCode:coordinate callback:callback];
        }
        else
        {
            callback(state, nil);
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
            HYLocateResultInfo *result = [[HYLocateResultInfo alloc] initWithDictionary:addr error:nil];
            if (result)
            {
                callback(HYLocateSuccess, result);
            }
        }
    }
    else
    {
        [self getAddressInfo:^(HYLocateState state, HYLocateResultInfo *result)
        {
            if (state >= HYLocateSuccess)
            {
                if (callback)
                {
                    callback(state, result);
                }
                NSDictionary *addrInfo = [result toDictionary];
                [[NSUserDefaults standardUserDefaults] setObject:addrInfo forKey:@"addrInfo"];
            }
            else
            {
                if (callback)
                {
                    callback(state, nil);
                }
            }
        }];
    }
}

- (HYLocateResultInfo *)getCacheAddress
{
    NSDictionary *addr = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"addrInfo"];
    if (addr)
    {
        HYLocateResultInfo *result = [[HYLocateResultInfo alloc] initWithDictionary:addr error:nil];
        return result;
    }
    else
    {
        return nil;
    }
}

- (void)clearAddressInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addrInfo"];
}

- (void)registerDefaultInfo
{
    HYLocateResultInfo *result = [[HYLocateResultInfo alloc] init];
    result.lat = 0;
    result.lon = 0;
    result.address = @"";
    result.city = @"深圳";
    
    NSDictionary *defaultD = [result toDictionary];;
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
    _locateState = HYReverseGeoSearchSuccess;
    if ([city length] > 0)
    {
        //去掉市字，无法在本地数据中检索
        NSString *last = [city substringFromIndex:(city.length-1)];
        if ([last isEqualToString:@"市"])
        {
            city = [city substringToIndex:(city.length-1)];
        }
        
        HYLocateResultInfo *resultInfo = [[HYLocateResultInfo alloc] init];
        resultInfo.city = city;
        resultInfo.address = location;
        resultInfo.streetName = result.addressDetail.streetName;
        
        CLLocationCoordinate2D userLoc = result.location;
        resultInfo.lat = userLoc.latitude;
        resultInfo.lon = userLoc.longitude;
        
        if (_geoSearchCallback)
        {
            _geoSearchCallback(_locateState, resultInfo);
        }
        _geoSearchCallback = nil;
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
    _locateState = HYIsLocating;
}

#pragma mark - 系统定位回调
//系统
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    _locateState = HYLocateSuccess;
    CLLocationCoordinate2D c = newLocation.coordinate;
    if (_systemLocateCallback)
    {
        HYLocateResultInfo *result = [[HYLocateResultInfo alloc] init];
        result.lat = c.latitude;
        result.lon = c.longitude;
        _systemLocateCallback(_locateState, result);
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
        HYLocateResultInfo *result = [[HYLocateResultInfo alloc] init];
        result.lat = c.latitude;
        result.lon = c.longitude;
        _systemLocateCallback(_locateState, result);
    }
    _systemLocateCallback = nil;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    _locateState = HYLocateFailed;
    if (_systemLocateCallback)
    {
        _systemLocateCallback(_locateState, nil);
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


@implementation HYLocateResultInfo

@end
