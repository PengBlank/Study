//
//  BusinessMainViewController.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//



#import "BusinessMainViewController.h"
#import "QRCodeEncoderViewController.h"
#import "SelectCityViewController.h"
#import "BusinessSearchViewController.h"
#import "BusinessDetailViewController.h"
#import "HYLocationManager.h"
#import "LocalCityManager.h"
#import "BusinessRootCtrl.h"
#import "HYAppDelegate.h"
#import "PersonGuideView.h"
#import "MainCarouselView.h"
#import "LocationErrorView.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
#import "UIButton+Common.h"
#import "UIImage+Common.h"
#import "UIImage+Addition.h"
#import "UIView+Common.h"
#import "NSString+Common.h"
#import "PayResultOfSceneCtrl.h"
#import "BusinessListInfo.h"
#import "SceneCategoryRequest.h"
#import "METoast.h"
#import "MJExtension.h"
#import "SceneCategoryInfo.h"
#import "SceneListInfo.h"
#import "UMSocialShakeService.h"
#import "SceneConsumDetailController.h"
#import "RefundViewController.h"
#import "TYAnalyticsManager.h"
#import "PageBaseLoading.h"
@interface BusinessMainViewController()<UIAlertViewDelegate,UMSocialUIDelegate,MainCarouselViewDelegate>
{
    CLLocationCoordinate2D  _coor;
    BOOL                    _isShare;
}

@property (nonatomic,strong) MainCarouselView   *mainView;
@property (nonatomic,strong) LocationErrorView  *locationView;
@property (nonatomic,strong) UIBarButtonItem    *leftBarItem;
@property (nonatomic,strong) UIBarButtonItem    *rightBarItem;
@property (nonatomic,strong) UIImageView        *myQRCode;

@property (nonatomic,strong) NSString           *cityName;
@property (nonatomic,strong) NSString           *tmpCityName;
@property (nonatomic,strong) UIButton           *cityBtn;
@property (nonatomic,strong) UIButton           *rightItem;
@property (nonatomic,strong) NSMutableArray     *CategotyDatas;

@property (nonatomic,strong) SceneCategoryRequest *sceneCategoryRequest;

@end

@implementation BusinessMainViewController

//#pragma mark - 懒加载

- (MainCarouselView *)mainView{
    if(!_mainView){
        _mainView = [[MainCarouselView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width,
                                                                kScreen_Height - kNavBarHeight - g_fitFloat(@[@48,@56.25,@62.10]))];
    }
    
    return _mainView;
}

- (LocationErrorView *)locationView{
    if (!_locationView) {
        _locationView = [[LocationErrorView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width,
                                                                            kScreen_Height - kNavBarHeight - 44 - g_fitFloat(@[@48,@56.25,@62.10]))];
    }
    return _locationView;
}

- (NSMutableArray *)CategotyDatas{
    if (!_CategotyDatas) {
        _CategotyDatas = [NSMutableArray array];
    }
    return _CategotyDatas;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [PageBaseLoading hiddeLoad_anyway];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.baseViewController setTabbarShow:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xffffff"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageWithNamedAutoLayout:@"logo_home"]];
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    [self getLocateStautus];
}

#pragma mark - 初始化导航左边item
- (UIBarButtonItem *)leftBarItem{
    
    if (!_leftBarItem)
    {
        UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cityButton.frame = CGRectMake(2, 0, 80, 30);
        [cityButton setImage:[UIImage imageNamed:@"map_opengrey"] forState:UIControlStateNormal];
        [cityButton setTitle:self.cityName ? : @"城市" forState:UIControlStateNormal];
        [cityButton setTitleColor:[UIColor colorWithHexString:@"0x343434"] forState:UIControlStateNormal];
        [[cityButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
        [cityButton addTarget:self action:@selector(cityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cityButton layoutButtonWithEdgeInsetsStyle:TYButtonEdgeInsetsStyleRight imageTitleSpace:10.0f];
        self.cityBtn = cityButton;
        _leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:cityButton];
    }
    return _leftBarItem;
}

#pragma mark - 初始化导航右边item
- (UIBarButtonItem *)rightBarItem{
    if (!_rightBarItem)
    {
        UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [switchButton setImage:[UIImage imageNamed:@"btn_searchgrye"] forState:UIControlStateNormal];
        switchButton.frame = CGRectMake(0, 0, 34, 24);
        [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.rightItem = switchButton;
        self.rightItem.hidden = YES;
        _rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:switchButton];
    }
    return _rightBarItem;
}

#pragma mark - 获取定位信息
- (void)getLocateStautus{

    WS(weakSelf);
    /**检查网络状态**/
    if (kNetworkNotReachability) {
        [self.view configBlankPage:EaseBlankPageTypeNoNetwork hasData:NO hasError:HasError
                 reloadButtonBlock:^(id sender) {
                     [weakSelf getLocateStautus];
                 }];
        return;
    }
    
//    [HYLoadHubView show];
    [PageBaseLoading showLoading];

    /**获取定位信息**/
    [[HYLocationManager sharedManager] getCacheAddressInfo:^(HYLocateState state, HYLocateResultInfo *result){
        
        if (state == HYLocateSuccess){
            NSString *city = result.city;
            _coor.latitude = result.lat;
            _coor.longitude = result.lon;
            
            weakSelf.tmpCityName = [LocalCityManager sharedManager].city;
            weakSelf.cityName = weakSelf.tmpCityName ? : city;
            [weakSelf.cityBtn setTitle: weakSelf.cityName forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(tableviewClick:)
                                                         name:kNotificationWithMainTableViewClick object:nil];
             [weakSelf loadData];

        }else{
            [weakSelf.view configBlankPage:EaseBlankPageMapViewLocationFailed hasData:NO hasError:HasError
                                  reloadButtonBlock:^(id sender) {
                                      [weakSelf getLocateStautus];
                                  }];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务（设置>隐私>定位服务>特奢汇）"
                                                        delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:@"设置",@"取消",nil];
            [av show];
            //[HYLoadHubView dismiss];;
             [PageBaseLoading hide_Load];
        }
    }];
}

#pragma mark - 加载数据
- (void)loadData{
    WS(weakSelf);
    
    //[HYLoadHubView show];
    [_sceneCategoryRequest cancel];
    _sceneCategoryRequest = nil;
    
    _sceneCategoryRequest               = [[SceneCategoryRequest alloc] init];
    _sceneCategoryRequest.interfaceURL  = [NSString stringWithFormat:@"%@/v4/Scene/GetTabList",BASEURL];
    _sceneCategoryRequest.httpMethod    = @"POST";
    _sceneCategoryRequest.postType      = JSON;
    _sceneCategoryRequest.interfaceType = DotNET2;

    [_sceneCategoryRequest sendReuqest:^(id result, NSError *error)
     {

         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             NSString *msg = objDic[@"msg"];
             if (code == 0) { //状态值为0 代表请求成功
                 NSArray *DateArray = objDic[@"data"];
                 weakSelf.CategotyDatas  = [SceneCategoryInfo objectArrayWithKeyValuesArray:DateArray];
                [PageBaseLoading hide_Load];
                 [weakSelf stupMainView];
                 
             }else{
                 [METoast toastWithMessage:msg ? : @"搜索商家信息失败"];
                 [PageBaseLoading hide_Load];
             }
         }else{
             [METoast toastWithMessage:@"搜索商家信息失败"];
             [PageBaseLoading hide_Load];
         }
         
         
     }];
}

#pragma mark - 创建主视图数据
- (void)stupMainView{
    
//    [self createMyQRCode];
//    [PageBaseLoading hiddeLoad_anyway];
    self.mainView.delegate = self;
    self.mainView.cityName = self.cityName;
    self.mainView.coor = _coor;
    self.mainView.dataArray = self.CategotyDatas;
   
    [self.view addSubview:_mainView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationChanged:)
                                                name:kNotificationHideMainPageNavRightItem object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareBtnClick:)
                                                name:kNotificationWithShareBlock object:nil];
}

- (void)MainCarouseQRcodeClick{
    [self myCode];
}


- (void)MainCarousePopPersonGuideView{

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PersonGuide"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    PersonGuideView *blackView = [[PersonGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [KEY_WINDOW addSubview:blackView];
}


- (void)notificationChanged:(NSNotification *)notif{
    UIButton *btn = [notif object];
    if (btn.tag == 0) {
        
        if ([self.rightItem isHidden]) {
            self.rightItem.hidden = NO;
        }
    }else{
        self.rightItem.hidden = YES;
    }
}

- (void)tableviewClick:(NSNotification *)notif{
    
    id model = notif.object;
    DebugNSLog(@"tableviewClickRow ： %@",model);
    if ([model isKindOfClass:[BusinessListInfo class]]) {
        BusinessDetailViewController *tmpCtrl = [[BusinessDetailViewController alloc] init];
        tmpCtrl.businessInfo = model;
        [self.baseViewController setTabbarShow:NO];
        [self.navigationController pushViewController:tmpCtrl animated:YES];
    }else {
        SceneConsumDetailController *sceneDetailController = [[SceneConsumDetailController alloc]init];
        sceneDetailController.packId = ((SceneListInfo *)model).packId;
        sceneDetailController.cityName = _cityName;
        sceneDetailController.shareImage = ((SceneListInfo *)model).tmpImage;
        sceneDetailController.pageType = ((SceneListInfo *)model).infoIndentifier;
        [self.baseViewController setTabbarShow:NO];
        [self.navigationController pushViewController:sceneDetailController animated:YES];
    }
}

- (void)shareBtnClick:(NSNotification *)notif{
    
    SceneListInfo *model = notif.object;
    
    if (!_isShare)
    {
        _isShare = YES;
        
        NSString *shareUrl = [NSString stringToUTF8:model.urlshare];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.title = model.packageName;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =shareUrl;
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        
//        DebugNSLog(@"%@",[NSString stringWithFormat:@"%@@100w_100h_1l_2e",model.url]);
//        
       UIImage *shareImage = nil;
        if (model.tmpImage) {
           // imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@180w_180h_1l_2e",model.url]]];
            shareImage = model.tmpImage;
        } else {
            shareImage =[UIImage imageNamed:@"share_icon"];
        }
        
        [UMSocialSnsService presentSnsIconSheetView:self.baseViewController
                                             appKey:uMengAppKey
                                          shareText:[NSString stringWithFormat:@"我在特奢汇上体验了一场别具一格的美食&娱乐盛宴 一起来吧！%@",shareUrl]
                                         shareImage:shareImage
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
                                           delegate:self];
    }

}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    DebugNSLog(@"分享平台：%@",platformName);
    // qq wxsession wxtimeline sina

}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
     DebugNSLog(@"分享fromViewControllerType");
    _isShare = NO;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
   NSArray *array = [response.data allKeys];
    if (array.count != 0) {
        
        NSString *platformName = [array firstObject];
        if ([platformName isEqualToString:@"qq"]) {
            [[TYAnalyticsManager sharedManager] sendAnalyseForSceneShareType:QQ];;
        } else if ([platformName isEqualToString:@"wxsession"]) {
             [[TYAnalyticsManager sharedManager] sendAnalyseForSceneShareType:WeChat];;
        } else if ([platformName isEqualToString:@"wxtimeline"]) {
            [[TYAnalyticsManager sharedManager] sendAnalyseForSceneShareType:TimeLine];;
        } else {
            [[TYAnalyticsManager sharedManager] sendAnalyseForSceneShareType:SinaWeibo];;
        }
    }
    _isShare = NO;
}

#pragma mark - 选择城市按钮
- (void)cityButtonPressed:(UIButton *)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideCategoryMenuItem object:nil];
    WS(weakSelf)
    citySelectBlock callback = ^(NSString *city)
    {
        self.cityName = city;
        [weakSelf.cityBtn setTitle:self.cityName forState:UIControlStateNormal];
        [weakSelf.cityBtn layoutButtonWithEdgeInsetsStyle:TYButtonEdgeInsetsStyleRight imageTitleSpace:10.0f];
        [weakSelf setCityDataWithCity:city];
    };
    SelectCityViewController *city = [[SelectCityViewController alloc] init];
    city.callback = callback;
    city.currentCity = self.cityName;
    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:city];
    [self.baseViewController setTabbarShow:NO];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 建立城市数据
- (void)setCityDataWithCity:(NSString *)city{
//    [HYLoadHubView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithSelecteCityBlock object:city];
}


#pragma mark - 切换按钮
- (void)switchButtonPressed{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideCategoryMenuItem object:nil];
    BusinessSearchViewController *vc = [[BusinessSearchViewController alloc] init];
    vc.cityName = self.cityName;
    vc.coor = _coor;
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:vc animated:YES];

}

//#pragma mark -- 创建我的二维码
//- (void)createMyQRCode{
//    
//    CGRect frame = [[UIScreen mainScreen] bounds];
//    _myQRCode = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QRImage"]];
//    _myQRCode.frame = CGRectMake(frame.size.width - 75,
//                                frame.size.height - g_fitFloat(@[@180,@190,@200]),
//                                65,
//                                65);
//    _myQRCode.userInteractionEnabled = YES;
//    
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
//                                                                         action:@selector(myCode)];
//    [_myQRCode addGestureRecognizer:tap];
//}

#pragma mark -- 点击二维码触发事件
- (void)myCode
{

    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!isLogin) {
        [self loginEvent];
    }else{
        QRCodeEncoderViewController *vc = [[QRCodeEncoderViewController alloc]init];
        [self.baseViewController setTabbarShow:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- private methods(登录)
- (void)loginEvent{
    HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loadLoginView];
}

#pragma mark -- alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)dealloc{
    
}


@end
