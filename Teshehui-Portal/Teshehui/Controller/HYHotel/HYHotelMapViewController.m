//
//  HYHotelMapViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-6-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelMapViewController.h"
#import "HYNavigationController.h"
#import "GTMBase64.h"
#import <MapKit/MapKit.h>
#import "Reachability.h"
#import "HYLocationManager.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h> 
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface HYHotelMapViewController ()
<
BMKLocationServiceDelegate
>
{
    BOOL _isSetMapSpan;
    
    NSMutableArray *_poiAnnotations;
    
    BMKPointAnnotation *_hotelAnotation;
    
    
    //选中的周边信息
    __weak UIButton *_selectedCircumBtn;
    NSArray *_circumBtns;
    BOOL _isGettingNewPOI;  //开始搜索时置为yes,获取回调时置为no, 在增加annotation时检测
    
    NSInteger _selectedBtnIdx;
    NSInteger _searchingBtnIdx;
    
    NSArray *_poiSearchKeys;
    
    CLLocationCoordinate2D _coor;
}

//导航功能的相关信息
//存储应用名称，导航url，
@property (nonatomic, strong) NSArray *naviMapInfo;

@property (nonatomic, strong) NSArray *circumImgs;

@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation HYHotelMapViewController

- (void)dealloc
{
    _mapView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSetMapSpan = NO;
        _coorType = HYCoorGeneral;
        _canNavigate = YES;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 48.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"check_map", nil);
    
    //地图
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    //poi 点
    _poiAnnotations = [NSMutableArray array];
    
    if (_canNavigate)
    {
        //导航按钮
        UIButton *navi = [UIButton buttonWithType:UIButtonTypeCustom];
        navi.frame = CGRectMake(0, 0, 48, 30);
        [navi setTitle:@"导航" forState:UIControlStateNormal];
        navi.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [navi setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        
        UIColor *titleColor = self.navBarTitleColor;
        [navi setTitleColor:titleColor
                   forState:UIControlStateNormal];
        [navi addTarget:self
                 action:@selector(naviBtnAction:)
       forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:navi];
        self.navigationItem.rightBarButtonItem = leftBarItem;
    }
    
    //周边按钮
    if (self.showAroundShops)
    {
        [self addCircumBtns];
    }
    
    
    _poiSearchKeys = @[@"美食", @"娱乐", @"景点", @"购物"];
}

- (void)addCircumBtns
{
    CGFloat s = 20; //竖间隔
    CGFloat x = CGRectGetWidth(self.view.frame) - 10 - 25;
    CGFloat h = 25;  //按钮高度+间隔
    CGFloat y = CGRectGetHeight(self.view.frame) - 4*h - 3*s - s;
    CGFloat w = 25;
    
    CGRect frame = CGRectMake(x, y, w, h);
    
    UIButton *foodBtn = [[UIButton alloc] initWithFrame:frame];
    foodBtn.tag = 1000;
    [self configCircumBtn:foodBtn];
    [self.view addSubview:foodBtn];
    
    frame.origin.y += h + s;
    UIButton *happyBtn = [[UIButton alloc] initWithFrame:frame];
    happyBtn.tag = 1001;
    [self configCircumBtn:happyBtn];
    [self.view addSubview:happyBtn];
    
    frame.origin.y += h + s;
    UIButton *viewBtn = [[UIButton alloc] initWithFrame:frame];
    viewBtn.tag = 1002;
    [self configCircumBtn:viewBtn];
    [self.view addSubview:viewBtn];
    
    frame.origin.y += h + s;
    UIButton *shopBtn = [[UIButton alloc] initWithFrame:frame];
    shopBtn.tag = 1003;
    [self configCircumBtn:shopBtn];
    [self.view addSubview:shopBtn];
    
    _circumBtns = [NSArray arrayWithObjects:foodBtn, happyBtn, viewBtn, shopBtn, nil];
}

//定制周边信息的按钮
//设置背景图片为 btn_imagName_on.png, btn_imgName_off.png
//设置title
- (void)configCircumBtn:(UIButton *)btn
{
    [self setBtnImage:btn isOn:NO];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [btn addTarget:self action:@selector(circumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
}

- (void)setBtnImage:(UIButton *)btn isOn:(BOOL)on
{
    NSInteger idx = btn.tag - 1000;
    NSString *imgName = nil;
    static NSArray *nameArr = nil;
    if (!nameArr)
    {
        nameArr = @[@"food", @"happy", @"view", @"shopping"];
    }
    imgName = [nameArr objectAtIndex:idx];
    NSString *suffix = on ? @"_on" : @"_off";
    imgName = [imgName stringByAppendingString:suffix];
    imgName = [NSString stringWithFormat:@"btn_%@.png", imgName];
    UIImage *img = [UIImage imageNamed:imgName];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    static NSArray *titles = nil;
    if (!titles)
    {
        titles = @[@"餐饮", @"娱乐", @"景点", @"购物"];
    }

    if (on)
    {
        NSString *title = [titles objectAtIndex:idx];
        [btn setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitle:nil forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    
    [self showUserLocation];
    
    //条件判断
    //显示酒店位置
    //if (self.hotelInfo)
    {
        [self showAnnotationWithLatitude:_location.latitude
                              longtitude:_location.longitude
                                   title:_annotationTitle];
    }
    
    //取消侧滑退出
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    if (nav && [nav isKindOfClass:[HYNavigationController class]])
    {
        [nav setEnableSwip:NO];
    }
}

- (void)showUserLocation
{
    _mapView.showsUserLocation = YES;
    
    // 判断定位操作是否被允许
    __weak typeof(self) b_self = self;
    [[HYLocationManager sharedManager] startTrace:^(HYLocateState state, BMKUserLocation *location)
     {
         if (state >= HYLocateSuccess)
         {
             [b_self.mapView updateLocationData:location];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务被禁用"
                                                             message:@"请重启定位服务，来获取您的位置信息"
                                                            delegate:nil
                                                   cancelButtonTitle:@"知道了"
                                                   otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    
    _searcher = nil;
    _searcher.delegate = nil;
    
    [[HYLocationManager sharedManager] stopTrace];
    
    //恢复侧滑退出
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    if (nav && [nav isKindOfClass:[HYNavigationController class]])
    {
        [nav setEnableSwip:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (!self.view.window)
    {
        _mapView.delegate = nil;
        _mapView = nil;
        _poiAnnotations = nil;
        _circumBtns = nil;
    }
}

#pragma mark - 周边
- (void)circumBtnAction:(id)sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    
    //点击按钮开始时禁用所有按钮以保证同步
    //这两个方法保证点击的元子操作性
    [self disableCircumBtns];
    
    UIButton *clickBtn = (UIButton *)sender;
    
    //两个变量分别指示select 和deselect动画的完成，
    //在最后的时候需要判断这两个变量以保证同步
    __block BOOL deselectCompleted = YES;
    __block BOOL selectCompleted = YES;
    
    //已有选中的按钮
    if (_selectedCircumBtn != nil)
    {
        //移除已有的poi点
        if (_poiAnnotations.count > 0)
        {
            [_mapView removeAnnotations:_poiAnnotations];
            [_poiAnnotations removeAllObjects];
        }
        
        //如果search非空,则有可能是处于已开始而还未得到结果的状态
        //需要取消之前的请求
        if (_searcher)
        {
            _searcher.delegate = nil;
            _searcher = nil;
        }
        
        deselectCompleted = NO;
        
        UIButton *selectedBtn = _selectedCircumBtn;
        [UIView animateWithDuration:.2 animations:^
        {
            CGRect frame = selectedBtn.frame;
            frame.origin.x = CGRectGetWidth(self.view.frame) - 25 - 10;
            frame.size.width = 25;
            selectedBtn.frame = frame;
        } completion:^(BOOL finished)
        {
            [self setBtnImage:selectedBtn isOn:NO];
            deselectCompleted = YES;
        }];
    }
    
    
    if (clickBtn != _selectedCircumBtn)
    {
        selectCompleted = NO;
        
        [self setBtnImage:clickBtn isOn:YES];
        _selectedBtnIdx = clickBtn.tag - 1000;
        [UIView animateWithDuration:.2 delay:0 options:0 animations:^
        {
            CGRect frame = clickBtn.frame;
            frame.origin.x = CGRectGetWidth(self.view.frame) - 62 - 10;
            frame.size.width = 62;
            clickBtn.frame = frame;
        } completion:^(BOOL finished)
        {
            _selectedCircumBtn = clickBtn;
            selectCompleted = YES;
        }];
        
    }
    else
    {
        _selectedCircumBtn = nil;
    }
    
    //等待动画完成
    while (!selectCompleted || !deselectCompleted)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
    
    [self enableCircumBtns];
    
    //由于baidu map 的bug这里检测网络连接，没有网络的情况下不进行搜索
    if ([[Reachability reachabilityForInternetConnection]
         currentReachabilityStatus] == NotReachable &&
        _selectedCircumBtn)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络未连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //开始搜索
    if (_selectedCircumBtn)
    {
        NSInteger tag = clickBtn.tag - 1000;
        if (_poiSearchKeys && _poiSearchKeys.count > tag)
        {
            _searcher.delegate = nil;
            
            CLLocationCoordinate2D desG = CLLocationCoordinate2DMake(_location.latitude, _location.longitude);
            CLLocationCoordinate2D desB = [self getBaiduFrom:desG coorType:HYCoorGeneral];
            _searchingBtnIdx = tag;
            
            _searcher = [[BMKPoiSearch alloc]init];
            _searcher.delegate = self;
            
            BMKNearbySearchOption *nearSearchOption = [[BMKNearbySearchOption alloc]init];
            nearSearchOption.pageIndex = 0;
            nearSearchOption.pageCapacity = 50;
            nearSearchOption.keyword = _poiSearchKeys[tag];
            nearSearchOption.location = desB;
            nearSearchOption.radius = 500;
            
            BOOL flag = [_searcher poiSearchNearBy:nearSearchOption];
            if (flag)
            {
                DebugNSLog(@"搜索周边成功");
            }
            
            _isGettingNewPOI = YES;
        }
    }
}

- (void)disableCircumBtns
{
    for (UIButton *btn in _circumBtns) {
        //btn.enabled = NO;
        btn.userInteractionEnabled = NO;
    }
}

- (void)enableCircumBtns
{
    for (UIButton *btn in _circumBtns) {
        //btn.enabled = YES;
        btn.userInteractionEnabled = YES;
    }
}

#pragma mark - POI搜索

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
        [_mapView setCenterCoordinate:_hotelAnotation.coordinate
                             animated:YES];
        
        _isGettingNewPOI = NO;
        
        _searcher.delegate = nil;
        _searcher = nil;
        if (_poiAnnotations)
        {
            [_mapView removeAnnotations:_poiAnnotations];
            [_poiAnnotations removeAllObjects];
        }
        
        for (BMKPoiInfo *poiInfo in poiResult.poiInfoList)
        {
            if (_isGettingNewPOI)
            {
                break;
            }
            
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            
            annotation.coordinate = poiInfo.pt;
            annotation.title = poiInfo.name;
            annotation.subtitle = poiInfo.address;
            [_mapView addAnnotation:annotation];
            
            [_poiAnnotations addObject:annotation];
        }
        if (_selectedCircumBtn.tag - 1000 == 2)
        {
            _mapView.zoomLevel = 17;
        } else
        {
            _mapView.zoomLevel = 19;
        }
    }
}
- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    
}

#pragma mark - 导航

- (NSArray *)naviMapInfo
{
    //if (!_naviMapInfo)
    {
        NSMutableArray *mapInfo = [NSMutableArray array];
        CLLocationCoordinate2D des = CLLocationCoordinate2DMake(_location.latitude, _location.longitude);
        
        //baidu
        NSString *baiduApp = [NSString stringWithFormat:@"baidumap://map"];
        NSURL *baiduAppURL = [NSURL URLWithString:baiduApp];
        if ([[UIApplication sharedApplication] canOpenURL:baiduAppURL])
        {
            CLLocationCoordinate2D dest = des;
            if (_coorType == HYCoorGeneral)
            {
                dest = [self getBaiduFrom:des coorType:HYCoorGeneral];
            } else if (_coorType == HYCoorBaidu) {
                //
            }
            
            NSString *baiduMapName = @"百度地图";
            NSString *baiduURL = [NSString stringWithFormat:@"baidumap://map/direction?destination=%lf,%lf&mode=driving&src=Teshehui",
                                  dest.latitude,
                                  dest.longitude];
            [mapInfo addObject:@{@"name": baiduMapName, @"url": baiduURL, @"id": @"baidu"}];
        }
        
        //高德
        NSString *gdApp = [NSString stringWithFormat:@"iosamap://map"];
        NSURL *gdAppURL = [NSURL URLWithString:gdApp];
        if ([[UIApplication sharedApplication] canOpenURL:gdAppURL]
            && _coorType == HYCoorGeneral)
        {
            NSString *gdMapName = @"高德地图";
            NSString *gdURL = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=Teshehui&backScheme=&lat=%f&lon=%f&dev=0",
                               des.latitude,
                               des.longitude];
            [mapInfo addObject:@{@"name": gdMapName, @"url": gdURL, @"id":@"gaode"}];
        }
        
        //google
        NSString *googleApp = [NSString stringWithFormat:@"comgooglemaps://map"];
        NSURL *googleAppURL = [NSURL URLWithString:googleApp];
        if ([[UIApplication sharedApplication] canOpenURL:googleAppURL]&&
            _coorType == HYCoorGeneral)
        {
            //CLLocationCoordinate2D orit = _mapView.userLocation.coordinate;
            NSString * googleMapName = @"Google Maps";
            /*NSString *googleURL = [NSString stringWithFormat:@"comgooglemaps://?saddr=%lf,%lf&daddr=%lf,%lf",
             ori.latitude,
             ori.longitude,
             des.latitude,
             des.longitude];*/
            NSString *googleURL = [NSString stringWithFormat:@"comgooglemaps://?daddr=%lf,%lf", des.latitude, des.longitude];
            [mapInfo addObject:@{@"name": googleMapName, @"url": googleURL, @"id": @"google"}];
        }
        
        //苹果自带
        NSString *appleMapName = @"苹果自带地图";
        NSString *appleURL = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%lf,%lf",
                              des.latitude,
                              des.longitude];
        [mapInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:appleMapName, @"name", appleURL, @"url", @"apple", @"id", nil]];
        
        //
        
        _naviMapInfo = [NSArray arrayWithArray:mapInfo];
    }
    return _naviMapInfo;
}

//导航不再需要定位，因为都只需要目的地坐标
- (void)naviBtnAction:(id)sender
{
    UIActionSheet *actionSt = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:nil];
    for (NSDictionary *mapInfo in self.naviMapInfo)
    {
        NSString *mapName = [mapInfo objectForKey:@"name"];
        if (mapName)
        {
            [actionSt addButtonWithTitle:mapName];
        }
    }
    
    [actionSt addButtonWithTitle:NSLocalizedString(@"cancel", nil)];
    [actionSt setCancelButtonIndex:_naviMapInfo.count];
    
    [actionSt showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //检测cancel按钮
    if (buttonIndex != _naviMapInfo.count)
    {
        //检测ios6系统地图调用
        if (buttonIndex == _naviMapInfo.count - 1 &&
            [[UIDevice currentDevice] systemVersion].floatValue >= 6.0)
        {
            CLLocationCoordinate2D to;
            //要去的目标经纬度
            to.latitude = _location.latitude;
            to.longitude = _location.longitude;
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];//调用自带地图（定位）
            //显示目的地坐标。画路线
            MKPlacemark *toPlace = [[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:toPlace];
            toLocation.name = _annotationTitle;
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                           launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                          
                                                                      forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
            
        }
        else
            //使用url调用app
        {
            NSInteger mapIdx = buttonIndex;
            NSDictionary *mapInfo = [self.naviMapInfo objectAtIndex:mapIdx];
            NSString *mapid = [mapInfo objectForKey:@"id"];
            if ([mapid isEqualToString:@"baidu"])
            {
                //初始化调启导航时的参数管理类
                BMKNaviPara* para = [[BMKNaviPara alloc]init];
                //指定导航类型
                para.naviType = BMK_NAVI_TYPE_NATIVE;
                
                //初始化终点节点
                BMKPlanNode* end = [[BMKPlanNode alloc]init];
                //指定终点经纬度
                CLLocationCoordinate2D coor2 = [self getBaiduFrom:_location coorType:_coorType];
                end.pt = coor2;
                //指定终点名称
                //end.name = _nativeEndName.text;
                //指定终点
                para.endPoint = end;
                
                //指定返回自定义scheme
                para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
                
                //调启百度地图客户端导航
                [BMKNavigation openBaiduMapNavigation:para];
            }
            else
            {
                NSString *URLString = [mapInfo objectForKey:@"url"];
                NSURL *URL = [NSURL URLWithString:URLString];
                [[UIApplication sharedApplication] openURL:URL];
            }
        }
    }
}

//在地图上显示目的地
- (void)showAnnotationWithLatitude:(double)lat
                        longtitude:(double)lon
                             title:(NSString *)title
{
    // 添加一个PointAnnotation
    BMKCoordinateRegion region;
    
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(0, 0);
    coor.latitude = lat;
    coor.longitude = lon;
    
    if (_coorType == HYCoorGeneral || _coorType == HYCoorGPS)
    {
        coor = [self getBaiduFrom:coor coorType:_coorType];
    }
    
    region.center = coor;
    region.span.latitudeDelta = 0;
    region.span.longitudeDelta = 0;
    [_mapView setRegion:region];
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    
    annotation.coordinate = coor;
    annotation.title = title;
    _hotelAnotation = annotation;
    [_mapView addAnnotation:annotation];
    
    _mapView.zoomLevel = 19;
    
}

#pragma mark - 地图

//大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //周边商铺泡泡
    if (annotation != _hotelAnotation)
    {
        if (_selectedCircumBtn != nil)
        {
            NSInteger idx = _selectedCircumBtn.tag - 1000;
            NSArray *identifiers = @[@"food", @"happy", @"view", @"shop"];
            NSString *identifier = [identifiers objectAtIndex:idx];
            
            BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (annotationView == nil)
            {
                annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
                ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
            }
            
            annotationView.annotation = annotation;//绑定对应的标点经纬度
            annotationView.canShowCallout = YES;//允许点击弹出气泡框
            
            static NSArray *bulbleArr = nil;
            if (!bulbleArr)
            {
                bulbleArr = [NSArray arrayWithObjects:@"icon_paopao_food.png", @"icon_paopao_happy.png", @"icon_paopao_view.png", @"icon_paopao_shopping.png", nil];
            }
            NSString *imgName = nil;
            if (_selectedCircumBtn)
            {
                NSInteger tag = _selectedCircumBtn.tag - 1000;
                imgName = [bulbleArr objectAtIndex:tag];
            }
            
            annotationView.image = nil;
            if (imgName)
            {
                annotationView.image = [UIImage imageNamed:imgName];
            }
            
            return annotationView;
        }
        
        return nil;
    }
    
    
    //酒店位置
    static NSString *AnnotationViewID = @"hotel";
    
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    return annotationView;
}

//坐标转换
- (CLLocationCoordinate2D)getBaiduFrom:(CLLocationCoordinate2D)coor coorType:(HYMapViewCoorType)type
{
    //NSLog(@"x:%lf, y:%lf", locationCoord.latitude, locationCoord.longitude);
    BMK_COORD_TYPE bType;
    if (type == HYCoorGPS)
    {
        bType = BMK_COORDTYPE_GPS;
    } else if (type == HYCoorGeneral){
        bType = BMK_COORDTYPE_COMMON;
    } else {
        bType = BMK_COORDTYPE_COMMON;
    }
    NSDictionary *baidudict =BMKConvertBaiduCoorFrom(CLLocationCoordinate2DMake(coor.latitude, coor.longitude), bType);
    CLLocationCoordinate2D result = BMKCoorDictionaryDecode(baidudict);
    return result;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
