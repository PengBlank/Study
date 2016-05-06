//
//  BusinessMapViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BusinessMapViewController.h"
#import "BusinessDetailViewController.h"
#import "QRCodeEncoderViewController.h"
#import "HYAppDelegate.h"

#import "HYLocationManager.h"
#import "MapMerchantRequest.h"
#import "SVPullToRefresh.h"

#import "BusinessRootCtrl.h"

#import "BusinessListInfo.h"
#import "BusinesslistCell.h"

#import "UIImage+Common.h"
#import "UIView+Common.h"
#import "UITableView+Common.h"
#import "UIView+Frame.h"

#import "MapViewCell.h"
#import "MapItemCell.h"
#import "DefineConfig.h"
#import "MJExtension.h"

#import "Masonry.h"
#import "BMapView.h"
#import "Item.h"
#import "METoast.h"
#import "UIUtils.h"
#import "BusinessTipView.h"


@interface BusinessMapViewController ()
<BMapViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
UIAlertViewDelegate>
{
        CLLocationCoordinate2D  _coor;
        NSInteger               _pageNumber;
}
@property (nonatomic, strong)   BMapView            *mapView;
@property (nonatomic, strong)   NSMutableArray      *annotations;
@property (nonatomic, strong)   MapMerchantRequest  *mapMerchantRequest;
//@property (nonatomic, assign)   BOOL                isNext;//下一页？
@property (nonatomic, assign)   BOOL                isLocationSuccess;//定位成功
@property (nonatomic, assign)   BOOL                isNoNetwork;//没有网络
@property (nonatomic, assign)   BOOL                isMapAnimationAgine;//大头针下落的效果
//@property (nonatomic, assign)   BOOL                isLeaveCurrentPage;//离开过当前页面？
@property (nonatomic, strong)   NSString            *localCity;
@property (nonatomic, strong)   UIButton            *pullBtn;
@property (nonatomic, strong)   UIView              *pullView;
@property (nonatomic, strong)   UIView              *btnBackgroudView;
@property (nonatomic, strong)   BusinessTipView     *tipView;
@end

@implementation BusinessMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [HYLoadHubView show];
    _baseTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:
                                  CGRectMake(ScaleHEIGHT(309), 0, kScreen_Width, kScreen_Height - g_fitFloat(@[@48,@56.25,@62.10]) - ScaleHEIGHT(309))
                                                              style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView;
    });
    _baseTableView.scrollEnabled = NO;
    [self.view addSubview:_baseTableView];
    
    UISwipeGestureRecognizer *recognizerUp;
    recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewHandleSwipeFrom:)];
    [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [_baseTableView addGestureRecognizer:recognizerUp];
    
    _pageNumber = 1;
    WS(weakSelf);

    [self.baseTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(ScaleHEIGHT(309), 0, g_fitFloat(@[@48,@56.25,@62.10]), 0));
    }];

    _isLocationSuccess = YES;
    
    [self getLocalBusinessList];
    [self createMyQRCode];
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (_isNormalLeakViewController) { //这里是条现金券不足页面的处理
        _isNormalLeakViewController = NO;
        [self.baseViewController setCurrentSelectIndex:2];
        return;
    }
    
    if ([self.navigationController isKindOfClass:[HYNavigationController class]])
    {
        HYNavigationController *nav = (HYNavigationController *)self.navigationController;
        [nav setEnableSwip:NO];
    }
    self.navigationController.navigationBarHidden = YES;
    [self.baseViewController setTabbarShow:YES];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

    WS(weakSelf);
    
    if (_isMapAnimationAgine) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           
               weakSelf.mapView.isOther = NO;
               [weakSelf.mapView setUserPosition];
               
               [weakSelf.mapView beginLoad];
               
               if (weakSelf.tipView.isHidden) {
                   [weakSelf.tipView show];
               }
                           
        });
    }

    if (!_isLocationSuccess) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务（设置>隐私>定位服务>特奢汇）"
                                                    delegate:self cancelButtonTitle:nil otherButtonTitles:@"设置",@"取消",nil];
        [av show];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    
    if ([self.navigationController isKindOfClass:[HYNavigationController class]])
    {
        HYNavigationController *nav = (HYNavigationController *)self.navigationController;
        [nav setEnableSwip:YES];
    }
    self.isMapAnimationAgine = YES;
    [self.mapView removeAnnotationView];
    [self.baseViewController setTabbarShow:NO];
    [self.mapMerchantRequest cancel];
     self.mapMerchantRequest = nil;
}


#pragma mark -- 重新定位地图数据
- (void)locationMe{
    
    if (!_isLocationSuccess) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务（设置>隐私>定位服务>特奢汇）"
                                                    delegate:self cancelButtonTitle:nil otherButtonTitles:@"设置",@"取消",nil];
        [av show];
        
        return;
    }
    
    [_tipView dismiss];
    _isLocationSuccess = YES;
   

    [self.mapView removeAnnotationView];
    self.mapView.isOther = NO;
    [self.mapView setUserPosition];
    [self.mapMerchantRequest cancel];
    self.mapMerchantRequest = nil;
    [self getLocalBusinessList];
}

#pragma mark -- 放大地图
- (void)largenMapView{
    [self.mapView largenMap];
}

#pragma mark -- 缩小地图
- (void)reduceMapView{
    [self.mapView reduceMap];
}

#pragma mark -- 创建我的二维码
- (void)createMyQRCode{
    //我的二维码
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIImageView *myQRCode = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QRImage"]];
    myQRCode.frame = CGRectMake(frame.size.width - 75,
                               frame.size.height - g_fitFloat(@[@120,@130,@140]),
                                65,
                                65);
    myQRCode.userInteractionEnabled = YES;
    [self.view addSubview:myQRCode];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(myCode)];
    [myQRCode addGestureRecognizer:tap];
}

#pragma mark -- 点击二维码触发事件
- (void)myCode
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!isLogin) {
        [self loginEvent];
    }else{
        QRCodeEncoderViewController *vc = [[QRCodeEncoderViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- private methods(登录)
- (void)loginEvent
{
    HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loadLoginView];
}

#pragma mark -- 获取定位信息
- (void)getLocalBusinessList
{
    WS(weakSelf);
    [HYLoadHubView show];
    
    if(!weakSelf.mapView){
        weakSelf.mapView = [[BMapView alloc] initWithDelegate:weakSelf];
        [weakSelf.mapView setFrame:CGRectMake(0, 0, kScreen_Width, ScaleHEIGHT(309))];
        [weakSelf.view addSubview:weakSelf.mapView];

        weakSelf.btnBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width - 50,  weakSelf.mapView.height - 140, 30, 100)];
        [weakSelf.btnBackgroudView setBackgroundColor:[UIColor clearColor]];
        [weakSelf.view insertSubview:weakSelf.btnBackgroudView aboveSubview:weakSelf.mapView];
        
        UIButton *mebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mebtn setFrame:CGRectMake(0, 0, 30, 30)];
        [mebtn setImage:[UIImage imageNamed:@"mapreposition"] forState:UIControlStateNormal];
        [mebtn addTarget:weakSelf action:@selector(locationMe) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.btnBackgroudView addSubview:mebtn];
        
        UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reduceBtn setFrame:CGRectMake(0, 40, 30, 30)];
        [reduceBtn setImage:[UIImage imageNamed:@"narrow"] forState:UIControlStateNormal];
        [reduceBtn addTarget:weakSelf action:@selector(reduceMapView) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.btnBackgroudView addSubview:reduceBtn];
        
        
        UIButton *largenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [largenBtn setFrame:CGRectMake(0,70, 30, 30)];
        [largenBtn setImage:[UIImage imageNamed:@"enlarge"] forState:UIControlStateNormal];
        [largenBtn addTarget:weakSelf action:@selector(largenMapView) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.btnBackgroudView addSubview:largenBtn];
        
    }
    if (!weakSelf.pullBtn) {
        
        weakSelf.pullView = [[UIView alloc] initWithFrame:CGRectMake(0, weakSelf.mapView.height - 10, kScreen_Width, 10)];
        [weakSelf.pullView setBackgroundColor:[UIColor whiteColor]];
        [weakSelf.view addSubview:weakSelf.pullView];
        weakSelf.pullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [weakSelf.pullBtn setFrame:CGRectMake(0,weakSelf.mapView.height - 47, kScreen_Width, 47)];
        
        if (kScreen_Width == 320) {
            [weakSelf.pullBtn setImage:[UIImage imageNamed:@"pullmap_5s"] forState:UIControlStateNormal];
            [weakSelf.pullBtn setImage:[UIImage imageNamed:@"pullmap_5s"] forState:UIControlStateHighlighted];
        }else{
            [weakSelf.pullBtn setImage:[UIImage imageNamed:@"pullmap"] forState:UIControlStateNormal];
            [weakSelf.pullBtn setImage:[UIImage imageNamed:@"pullmap"] forState:UIControlStateHighlighted];
        }
        [weakSelf.view addSubview:weakSelf.pullBtn];
        
        UISwipeGestureRecognizer *recognizerUp;
        recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:weakSelf action:@selector(handleSwipeFrom:)];
        [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [weakSelf.pullBtn addGestureRecognizer:recognizerUp];
        
        UISwipeGestureRecognizer *recognizerDown;
        recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:weakSelf action:@selector(handleSwipeFrom:)];
        [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [weakSelf.pullBtn addGestureRecognizer:recognizerDown];
        
    }
    
    if (kNetworkNotReachability) {
        [HYLoadHubView dismiss];
        [weakSelf.baseTableView configBlankPage:EaseBlankPageTypeNoNetwork hasData:NO hasError:[[NSError alloc] init]
                              reloadButtonBlock:^(id sender) {
                                  [weakSelf getLocalBusinessList];
                              }];
         [weakSelf.annotations removeAllObjects];
        [weakSelf.baseTableView reloadData];
        return ;
    }
    
   [[HYLocationManager sharedManager] getCacheAddressInfo:^(HYLocateState state, HYLocateResultInfo *result){
       
         if (state == HYLocateSuccess || state == HYReverseGeoSearchSuccess)
         {
             weakSelf.isLocationSuccess = YES;
             weakSelf.localCity = result.city;
             _coor.latitude = result.lat;
             _coor.longitude = result.lon;
             
             weakSelf.mapView.coor = _coor;
            [weakSelf.mapView setUserPosition];

            [weakSelf sendRequest];
         }
         else
         {
            [HYLoadHubView dismiss];

             if (kNetworkNotReachability) {
                [weakSelf.baseTableView configBlankPage:EaseBlankPageTypeNoNetwork hasData:NO hasError:[[NSError alloc] init]
                                      reloadButtonBlock:^(id sender) {
                    [weakSelf getLocalBusinessList];
                }];
                 
             }else{
                 
                 weakSelf.isLocationSuccess = NO;
                 _coor.latitude = 22.5372970000; //定位失败，默认深圳
                 _coor.longitude = 114.0283290000;
                 weakSelf.mapView.coor = _coor;
                 
                 [weakSelf.baseTableView configBlankPage:EaseBlankPageMapViewLocationFailed hasData:NO hasError:[[NSError alloc] init]
                                       reloadButtonBlock:^(id sender) {
                     [weakSelf getLocalBusinessList];
                 }];
                 [weakSelf.annotations removeAllObjects];
                 [weakSelf.baseTableView reloadData];

                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务（设置>隐私>定位服务>特奢汇）"
                                                             delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:@"设置",@"取消",nil];
                 [av show];
             }
         }

     }];
}

#pragma mark -- 网络数据请求（加载附近商家数据）
- (void)sendRequest{
    
    [self.mapMerchantRequest cancel];
    self.mapMerchantRequest = nil;
    
     WS(weakSelf);
    self.mapMerchantRequest = [[MapMerchantRequest alloc] init];
    self.mapMerchantRequest.interfaceURL    = [NSString stringWithFormat:@"%@/v3/Merchants/GetNearMerchants",BASEURL];
    self.mapMerchantRequest.interfaceType   = DotNET2;
    self.mapMerchantRequest.httpMethod      = @"POST";
    self.mapMerchantRequest.postType        = JSON;
    self.mapMerchantRequest.Longitude       = _coor.longitude;
    self.mapMerchantRequest.Latitude        = _coor.latitude;
    self.mapMerchantRequest.PageIndex       = _pageNumber;
    self.mapMerchantRequest.PageSize        = 500;
    self.mapMerchantRequest.City            = self.localCity;
    
    [ self.mapMerchantRequest sendReuqest:^(id result, NSError *error)
     {
 
         NSMutableArray  *objArray = nil;
         if(result){

             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             NSString *msg = objDic[@"msg"];
            
             if (code == 0) { //状态值为1 代表请求成功
                 NSArray *DateArray = objDic[@"data"];
                 objArray  = [BusinessListInfo objectArrayWithKeyValuesArray:DateArray];
                 
             }else{
                 [METoast toastWithMessage: msg ? msg : @"获取附近商家信息失败"];
             }
         }else{
             
             if (error.code == 1) {
                 
                 [weakSelf.baseTableView configBlankPage:EaseBlankPageTypeNoNetwork hasData:NO hasError:[[NSError alloc] init]
                                       reloadButtonBlock:^(id sender) {
                     weakSelf.isNoNetwork = YES;
                     [weakSelf getLocalBusinessList];
                 }];
                 [HYLoadHubView dismiss];
                 return ;

             }
             [METoast toastWithMessage:@"无法连接服务器"];
         }
     
         [weakSelf updateBusinessListData:objArray error:error];
     }];
}


#pragma mark -- 剪头上下滑动手势触发事件
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    if (!_isLocationSuccess && _mapView.height != kScreen_Height - g_fitFloat(@[@48,@56.25,@62.10])) {
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务（设置>隐私>定位服务>特奢汇）"
                                                  delegate:self cancelButtonTitle:nil otherButtonTitles:@"设置",@"取消",nil];
        [av show];
        
        return;
    }
    
    
    WS(weakSelf);
    switch (gestureRecognizer.direction) {
        case UISwipeGestureRecognizerDirectionUp:
        {
            
            if (_mapView.height == kScreen_Height - g_fitFloat(@[@48,@56.25,@62.10])) {
                [_mapView setHeight:ScaleHEIGHT(309)];
                
                 [weakSelf.btnBackgroudView setY: weakSelf.mapView.height - 140];
                [_pullView setY:_mapView.height - 10];
                [_pullBtn setY:_mapView.height - 47];
                [_pullBtn setImage:[UIImage imageNamed:@"pullmap"] forState:UIControlStateNormal];
                
                [weakSelf.baseTableView setY:ScaleHEIGHT(309)];
                return;
            }
            [self pullButtonClick];
        }
            break;
        case UISwipeGestureRecognizerDirectionDown:
        {
            
            [weakSelf.baseTableView setY:kScreen_Height - g_fitFloat(@[@48,@56.25,@62.10])];
            
            [_mapView setHeight:kScreen_Height - g_fitFloat(@[@48,@56.25,@62.10])];
            
             [weakSelf.btnBackgroudView setY: weakSelf.mapView.height - g_fitFloat(@[@175,@185,@195])];
            
            [_pullView setY:_mapView.height - 9];
            [_pullBtn setY:_mapView.height - 46];
            if (kScreen_Width == 320) {
                [weakSelf.pullBtn setImage:[UIImage imageNamed:@"pullmap_up_5s"] forState:UIControlStateNormal];
            }else{
                [weakSelf.pullBtn setImage:[UIImage imageNamed:@"pullmap_up"] forState:UIControlStateNormal];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- tableView上下滑动手势触发事件
- (void)tableViewHandleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    if (!_isLocationSuccess) {
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务（设置>隐私>定位服务>特奢汇）"
                                                  delegate:self cancelButtonTitle:nil otherButtonTitles:@"设置",@"取消",nil];
        [av show];
        
        return;
    }
    
    [self pullButtonClick];
}

#pragma mark -- 上下滑动手势的跳转触发事件
- (void)pullButtonClick{
    
   //  _isLeaveCurrentPage = YES;
    BusinessRootCtrl *vc = [[BusinessRootCtrl alloc] init];
    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:vc];
    [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- 商家列表数据绑定
- (void)updateBusinessListData:(NSMutableArray *)objArray error:(NSError *)error{

    if(self.annotations == nil){
        self.annotations = [[NSMutableArray alloc] init];
    }

 //   if (!_isNext) {
        [self.annotations removeAllObjects];
   // }
    [self.annotations addObjectsFromArray:objArray];

    
    WS(weakSelf);
   // if (!_isNext) {

        [self.baseTableView configBlankPage:EaseBlankPageNoMerchant hasData:objArray.count > 0 hasError:error
                          reloadButtonBlock:^(id sender) {
            [HYLoadHubView show];
            [weakSelf sendRequest];
        }];
   // }
    [self.baseTableView reloadData];
    if (self.annotations.count != 0) {
        self.isMapAnimationAgine = NO;
        [self loadMapView];
    }
    [HYLoadHubView dismiss];
}

#pragma mark -- 加载大头针以及显示发现多少家商家
- (void)loadMapView{
    
    [self.mapView beginLoad];
    
    if (!_tipView) {
        _tipView = [[BusinessTipView alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - (kScreen_Width - 20)/2, kNavBarHeight, kScreen_Width - 20, 44)
                                              businessNum:_annotations.count];
        [self.view addSubview:_tipView];
    }
    
    [_tipView show];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_annotations.count > 4) {
        return 4;
    }else{
        return self.annotations.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return g_fitFloat(@[@64.5,@75.5,@83.5]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"MapViewCell";
    MapViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MapViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell setWithShopToMapView:self.annotations[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusinessDetailViewController *tmpCtrl = [[BusinessDetailViewController alloc] init];
    BusinessListInfo *bInfo = self.annotations[indexPath.row];
    tmpCtrl.businessInfo = bInfo;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell1 forRowAtIndexPath:(NSIndexPath *)indexPath{
    MapViewCell *cell = (MapViewCell *)cell1;
    [cell displayBottomLine:YES isLast:YES];
}

#pragma mark -map
#pragma mark delegate

- (NSInteger)numbersWithCalloutViewForMapView
{
    return _annotations.count;
}

- (CLLocationCoordinate2D)coordinateForMapViewWithIndex:(NSInteger)index
{
    BusinessListInfo *item = [self.annotations objectAtIndex:index];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = item.Latitude;
    coordinate.longitude = item.Longitude;
    return coordinate;
}

- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"positionred36x70"];
}

- (UIView *)mapViewCalloutContentViewWithIndex:(NSInteger)index
{
    if (index == MaxTag) {
        return nil;
    }
    BusinessListInfo *item = [self.annotations objectAtIndex:index];
    MapItemCell *cell = [[MapItemCell alloc] initWithFrame:CGRectMake(0,0, kScreen_Width - 70, g_fitFloat(@[@73,@70,@70]))];
    cell.title.text = item.MerchantsName;
    cell.subTitle.text = item.AddressDetail;
    return cell;
}

- (void)calloutViewDidSelectedWithIndex:(NSInteger)index{

    BusinessDetailViewController *tmpCtrl = [[BusinessDetailViewController alloc] init];
    BusinessListInfo *bInfo = self.annotations[index];
    tmpCtrl.businessInfo = bInfo;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

-(void)clickMapVieWToLargenView{

    if (_mapView.height == kScreen_Height - g_fitFloat(@[@48,@56.25,@62.10])) {
        return;
    }
    
    
    WS(weakSelf);
    [UIView animateWithDuration:.5 animations:^{

        [weakSelf.baseTableView setY:kScreen_Height - g_fitFloat(@[@48,@56.25,@62.10])];
        
        [weakSelf.mapView setHeight:kScreen_Height - g_fitFloat(@[@48,@56.25,@62.10])];
        [weakSelf.btnBackgroudView setY: weakSelf.mapView.height - g_fitFloat(@[@175,@185,@195])];
        
        [weakSelf.pullView setY:weakSelf.mapView.height - 9];
        [weakSelf.pullBtn setY:weakSelf.mapView.height - 46];
        if (kScreen_Width == 320) {
            [weakSelf.pullBtn setImage:[UIImage imageNamed:@"pullmap_up_5s"] forState:UIControlStateNormal];
        }else{
            [weakSelf.pullBtn setImage:[UIImage imageNamed:@"pullmap_up"] forState:UIControlStateNormal];
            
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}


@end
