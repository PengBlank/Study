
//
//  HYMallHomeV2ViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeViewController.h"
#import "HYMallHomeModalAdsView.h"
#import "HYStartAdsDataController.h"
#import "HYMallHomeModalAdsViewModel.h"
#import "HYInterestSelectViewController.h"



#import "HYHomeMoreView.h"
//ViewControllers
#import "HYAppDelegate.h"
#import "HYMallProductListViewController.h"
#import "HYFlowerDetailViewController.h"
#import "HYActivityProductListViewController.h"
#import "HYActivityTemplateViewController.h"
#import "HYFlowerSubListViewController.h"
#import "HYProductDetailViewController.h"
#import "HYMallHomeHeaderView.h"

#import "HYQRCodeReaderViewController.h"
#import "HYMallSearchViewController.h"
#import "HYVipUpdateViewController.h"
#import "QRCodeEncoderViewController.h"
#import "PTHttpManager.h" 
#import "HYUserInfo.h"
#import "HYTabbarViewController.h"
#import "HYImageButton.h"
#import "UIColor+hexColor.h"
#import "UIImage+Addition.h"
//#import "HYCategoryViewController.h"
#import "HYCateBrandViewController.h"
#import "HYChannelViewController.h"
#import "HYShowHandViewController.h"
#import "HYMallWebViewController.h"
#import "HYSecondKillViewController.h"

#include "HYMallHomeSections.h"

//data and requests
#import "HYMallMoreGoodsRequest.h"
#import "HYMallHomePageRequest.h"
#import "HYMallRecommendRequest.h"
#import "HYGetTranscationTypeRequest.h"
#import "HYSearchHotKeyRequest.h"
#import "HYAnalyticsManager.h"

//refresh
#import "MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "UIAlertView+BlocksKit.h"

//cache
#import "HYHomeStore.h"
#import "HYBusinessTypeDao.h"

//new
#import "HYMallHomeViewModel.h"
#import "HYMallHomeView.h"
#import "HYMallHomeService.h"
#import "YYCache.h"
#import "HYShakeViewController.h"
#import "HYScannerViewController.h"
#import "UINavigationBar+Awesome.h"

//earnCashTicket
#import "HYFlightSearchViewController.h"
#import "HYHotelMainViewController.h"
#import "HYGroupProtocolViewController.h"
#import "HYQRCodeEncoderViewController.h"
#import "HYCIBaseInfoViewController.h"
#import "HYCallTaxiViewController.h"
#import "HYPhoneChargeViewController.h"
#import "HYFlowerMainViewController.h"
#import "HYMeituanViewController.h"


@interface HYMallHomeViewController ()
<
HYVipUpdateViewControllerDelegate,
UITextFieldDelegate,
HYMallHomeViewDelegate>
{
    BOOL _isLoading;
}

//@property (nonatomic, strong) HYMallHomeView *view;
@property (nonatomic, strong) HYMallHomeViewModel *viewModel;
@property (nonatomic, strong) HYMallHomeService *homeService;


//@property (nonatomic, strong) UIBarButtonItem *moreItemBar;
@property (nonatomic, strong) UIBarButtonItem *searchItemBar;
@property (nonatomic, strong) UIBarButtonItem *cateItemBar;
@property (nonatomic, strong) UIImageView *navtitleLogoImage;
@property (nonatomic, strong) HYImageButton *cateButton;
@property (nonatomic, strong) HYImageButton *searchButton;
/** 导航栏背景色 */
@property (nonatomic, strong) UIColor *navigationbarColor;
/** 导航栏按钮透明度 */
@property (nonatomic, assign) CGFloat alpha;

@property (nonatomic, strong) NSArray *supportTyps;
@property (nonatomic, strong) HYStartAdsDataController *dataCtrl;


//热搜词
@property (nonatomic, strong) HYSearchHotKeyRequest *hotKeyRequest;
@property (nonatomic, strong) HYSearchHotKey *searchKey;

@property (nonatomic, strong) YYCache *interestCache;

@end

@implementation HYMallHomeViewController


- (void)dealloc
{
    [_hotKeyRequest cancel];
    _hotKeyRequest = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
        [self fetchAdsData];
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.view = [[HYMallHomeView alloc] initWithFrame:frame];
    [(HYMallHomeView *)self.view setDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSupportBusinessType];
    [self reloadAllData];
    
    [self getHotKeys];
    
    //加载广告的item
    if (self.item)
    {
        [self checkBannerItem:self.item withBoard:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(routeAction:)
                                                 name:kHomeRouteNotification
                                               object:nil];
    
    _navigationbarColor = [UIColor clearColor];
    _alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    
    [self.navigationController.navigationBar lt_setBackgroundColor:_navigationbarColor];
    
    [self.baseViewController setTabbarShow:YES];
    
    //检测是否超过一天没更新
    [self checkNeedUpdateData];
    
    self.navigationItem.leftBarButtonItem = self.cateItemBar;
//    self.navigationItem.rightBarButtonItem = self.moreItemBar;
    self.navigationItem.rightBarButtonItem = self.searchItemBar;
//    self.navigationItem.titleView = self.searchView;
    self.navigationItem.titleView = self.navtitleLogoImage;
//    [self setupNavigationItemAlpha:0.0f];
    [self setupNavigationItemAlpha:_alpha];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [(HYMallHomeView *)self.view updateNavgationbarAlpha];
    
    //统计
    [HYAnalyticsManager sendHomeVisitReq];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.frame = [[UIScreen mainScreen] bounds];
}

#pragma mark setter/getter
- (UIImageView *)navtitleLogoImage
{
    if (!_navtitleLogoImage)
    {
        UIImage *logoImage = [UIImage imageWithNamedAutoLayout:@"logo_home"];
        UIImageView *navtitleView = [[UIImageView alloc] initWithImage:logoImage];
        navtitleView.frame = TFRectMake(0, 0, 45, 16);
        _navtitleLogoImage = navtitleView;
    }
    return _navtitleLogoImage;
}

- (UIBarButtonItem *)searchItemBar
{
    if (!_searchItemBar)
    {
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.frame = CGRectMake(0, 0, 48, 30);
//        
//        UIImage *back_n = [UIImage imageNamed:@"i_search"];
        //UIImage *back_s = [UIImage imageNamed:@"btn_back_arrow_focus"];
//        [backButton setImage:back_n forState:UIControlStateNormal];
//        
//        [backButton addTarget:self
//                       action:@selector(searchItemAction:)
//             forControlEvents:UIControlEventTouchUpInside];
        HYImageButton *searchButton = [HYImageButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(0, 0, 48, 30);
        _searchButton = searchButton;
        
        UIImage *back_n = [UIImage imageNamed:@"icon_home_newsearch"];
        
        [searchButton setImage:back_n forState:UIControlStateNormal];
        searchButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [searchButton addTarget:self
                       action:@selector(searchItemAction:)
             forControlEvents:UIControlEventTouchUpInside];
        [searchButton setTitleColor:[UIColor grayColor]
                         forState:UIControlStateNormal];
        searchButton.spaceInTestAndImage = 2;
        
        _searchItemBar = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    }
    return _searchItemBar;
}

- (UIBarButtonItem *)cateItemBar
{
    if (!_cateItemBar)
    {
        HYImageButton *cateButton = [HYImageButton buttonWithType:UIButtonTypeCustom];
        cateButton.frame = CGRectMake(0, 0, 48, 30);
        _cateButton = cateButton;
        
        UIImage *back_n = [UIImage imageNamed:@"icon_home_newbrand"];
        //UIImage *back_s = [UIImage imageNamed:@"btn_back_arrow_focus"];
        
        [cateButton setImage:back_n forState:UIControlStateNormal];
        cateButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [cateButton setTitle:@"品牌" forState:UIControlStateNormal];
        [cateButton addTarget:self
                       action:@selector(cateItemAction:)
             forControlEvents:UIControlEventTouchUpInside];
        [cateButton setTitleColor:[UIColor grayColor]
                         forState:UIControlStateNormal];
        cateButton.spaceInTestAndImage = 2;
        _cateItemBar = [[UIBarButtonItem alloc] initWithCustomView:cateButton];
    }
    return _cateItemBar;
}

- (void)cateItemAction:(id)sender
{
//    Class class = NSClassFromString(@"HYTaxiProcessViewController");
//    id vc = [[class alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    [self.baseViewController setTabbarShow:NO];
//    return;
    HYCateBrandViewController *cate = [[HYCateBrandViewController alloc] init];
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:cate animated:YES];
    
    //分类、品牌图标
    [MobClick event:@"v430_shangcheng_shouye_feileitubiao_jishu"];
}

- (HYMallHomeService *)homeService
{
    if (!_homeService) {
        _homeService = [[HYMallHomeService alloc] init];
    }
    return _homeService;
}

- (YYCache *)interestCache
{
    if (!_interestCache) {
        _interestCache = [YYCache cacheWithName:@"interestCache"];
    }
    return _interestCache;
}


#pragma mark private methods
/** 设置导航栏按钮透明度 */
- (void)setupNavigationItemAlpha:(CGFloat)alpha
{
    if (alpha == 0)
    {
        _cateButton.hidden = YES;
        _searchButton.hidden = YES;
        _navtitleLogoImage.hidden = YES;
    }
    else
    {
        _cateButton.hidden = NO;
        _searchButton.hidden = NO;
        _navtitleLogoImage.hidden = NO;
    }
    _cateButton.alpha = alpha;
    _searchButton.alpha = alpha;
    _navtitleLogoImage.alpha = alpha;
}

- (void)getHotKeys
{
    [HYLoadHubView show];
    self.hotKeyRequest = [[HYSearchHotKeyRequest alloc] init];
    __weak typeof(self) weakSelf = self;
    [_hotKeyRequest sendReuqest:^(HYSearchHotKeyResponse* result, NSError *error){
        [HYLoadHubView dismiss];
        if (result && result.status == 200)
        {
            weakSelf.searchKey = result.hotKeys.count > 0 ? result.hotKeys[0] : nil;
        }
    }];
}

- (void)fetchAdsData
{
    _dataCtrl = [[HYStartAdsDataController alloc]init];
    WS(weakSelf);
    [_dataCtrl fetchAllAdsDataWithCallback:^(id board) {
        
    } andSecBlock:^(id board) {
        //启动首页之后的广告
        [weakSelf renderHomeAdsViewWithData:board];
    }];
}

- (void)renderHomeAdsViewWithData:(HYMallHomeBoard *)data
{
    HYMallHomeModalAdsViewModel *viewModel = [HYMallHomeModalAdsViewModel viewModelWithSubject:data];
    HYMallHomeModalAdsView *view = [HYMallHomeModalAdsView adsView];
    view.delegate = self;
    [view setupScrollViewWithModel:viewModel];
}

- (void)searchItemAction:(id)sender
{
    //搜索输入框
    [MobClick event:@"v430_shangcheng_shouye_feileitubiao_jishu"];
    
    HYMallSearchViewController *search = [[HYMallSearchViewController alloc] initWithNibName:@"HYMallSearchViewController"
                                                                                      bundle:nil];
    search.searchKeyWord = self.searchKey ? self.searchKey.keyword : @"搜索全部商品";
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)routeAction:(NSNotification *)notice
{
    id param = notice.object;
    if ([param isKindOfClass:[HYMallHomeItem class]]) {
        [self checkBannerItem:param withBoard:nil];
    }
    else if ([param isKindOfClass:[NSArray class]]) {
        if ([param count] > 1) {
            [self checkBannerItem:param[0] withBoard:param[1]];
        }
    }
}

- (void)checkLogin:(void (^)(void))callback
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!isLogin)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
    else
    {
        callback();
    }
}

#pragma mark - datas
/** 导航栏透明度渐变 */
- (void)navigationBarAlphaWithColor:(UIColor *)color alpha:(CGFloat)alpha
{
    _alpha = alpha;
    UIColor *navigationbarColor = [color colorWithAlphaComponent:alpha];
    _navigationbarColor = navigationbarColor;
    [self.navigationController.navigationBar lt_setBackgroundColor:navigationbarColor];
    [self setupNavigationItemAlpha:alpha];
}

/** 导航栏透明 */
- (void)navigationBarAlphaWithColor:(UIColor *)color
{
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    [self setupNavigationItemAlpha:0];
    _alpha = 0;
}

- (void)loadSupportBusinessType
{
    [self.homeService fetchTransactionTypes:^(NSArray *types) {
        HYBusinessTypeDao *dao = [[HYBusinessTypeDao alloc] init];
        [dao saveEntities:types];
    }];
}


- (void)reloadAllData
{
    //清除数据
    [self.viewModel cleanAllMemoryData];
    
    // 重新加载
    [self reloadHomePageWithDataChange:NO];
}

- (void)homeViewWillLoadMoreData
{
    if (!_isLoading)
    {
        _viewModel.pageNumber++;
        [self loadProduct];
    }
}

- (void)reloadHomePageWithDataChange:(BOOL)hasChange
{
    //首页缓存数据
    NSArray *cacheItems = [HYHomeStore getCachedItems];
    if (cacheItems)
    {
        [self updateWithHomeItems:cacheItems];
    }
    
    NSArray *cacheTags = (NSArray *)[self.interestCache objectForKey:@"items"];
    if (![cacheTags isKindOfClass:[NSArray class]]) {
        cacheTags = nil;
    }
    
    //在线获取,更新推荐的时候，需要处理和缓存的重复问题
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [self.homeService loadHomeBoardsWithInterestTags:cacheTags
                                           isChanged:hasChange
                                            callback:^(NSArray *boards, NSError *err) {
        [HYLoadHubView dismiss];
                                                
        if (err)
        {
            
        }
        else
        {
            [HYHomeStore cacheHomeItems:boards];
            [b_self updateWithHomeItems:boards];
        }
    }];
}

- (void)updateWithHomeItems:(NSArray *)homeItems
{
    HYMallHomeViewModel *viewmodeo = [[HYMallHomeViewModel alloc] initWithHomeItems:homeItems];
    self.viewModel = viewmodeo;
    [(HYMallHomeView *)self.view setupWithModel:viewmodeo];
}

//检查数据更新, 超过一天没更新数据时更新数据
//在viewWillApear方法中调用
- (void)checkNeedUpdateData
{
    NSTimeInterval time = [[NSUserDefaults standardUserDefaults] doubleForKey:kHomeDataUpdateTime];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    if (nowTime-time > (24*60*60))
    {
        [self reloadAllData];
        
        [[NSUserDefaults standardUserDefaults] setDouble:nowTime forKey:kHomeDataUpdateTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)loadProduct
{
    if (!_isLoading)
    {
        _isLoading = YES;
        WS(weakSelf);
        [self.homeService loadRecmGoodsWithPage:self.viewModel.pageNumber callback:^(NSArray *goods) {
            [weakSelf updateProducts:goods];
        }];
    }
}

- (void)updateProducts:(NSArray *)products
{
    _viewModel.hasMore = products.count > 0;
    _isLoading = NO;
    
    if ( _viewModel.hasMore)
    {
        [self.viewModel addMoreProducts:products];
    }
}

- (void)checkBoard:(NSInteger)boardType itemAtIndex:(NSInteger)idx
{
    HYMallHomeBoard *board = [self.viewModel boardWithType:boardType];
    HYMallHomeItem *item = idx < board.programPOList.count ? board.programPOList[idx] : nil;
    [self checkBannerItem:item withBoard:board];
}

- (void)checkInterestTags
{
    HYInterestSelectViewController *interVC = [[HYInterestSelectViewController alloc] init];
    interVC.supportSkip = YES;
    [self.baseViewController presentViewController:interVC
                       animated:YES
                     completion:nil];
    WS(weakSelf);
    self.interestCache = [YYCache cacheWithName:@"interestCache"];
    interVC.didSelectedInterest = ^(BOOL hasChange){
        [weakSelf reloadHomePageWithDataChange:hasChange];
    };
}

- (void)checkMoreBrand
{
    [self cateItemAction:nil];
}

#pragma mark - 各种界面跳转
#pragma mark - HYMallProductListCellDelegate
- (void)checkBannerItem:(id)product withBoard:(id)board
{
    if ([product isKindOfClass:[HYMallHomeItem class]])
    {
        HYMallHomeItem *item = (HYMallHomeItem *)product;
//        HYMallHomeBoard *homeBoard = (HYMallHomeBoard *)board;
        HYMallHomeBoard *homeBoard = nil;
        if ([board isKindOfClass:[HYMallHomeBoard class]]) {
            homeBoard = (HYMallHomeBoard *)board;
        }
        
        /// 这里执行自定义标签页的逻辑处理，目前与后面有冗余，但是真的处理不了了。。。
        if (homeBoard.boardType == MallHomeInterestTag)
        {
            switch ((HYInterestTagType)item.itemType) {
                case HYInterestTagChannel:
                {
                    HYChannelViewController *vc = [[HYChannelViewController alloc] init];
                    [self.baseViewController setTabbarShow:NO];
                    vc.channelCode = item.channelCode;
                    vc.channelName = item.name;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    //统计
                    [HYAnalyticsManager sendProductListVisitWithBannerItem:item
                                                                     board:board
                                                                  fromPage:1
                                                                     stgid:self.stgId];
                }
                    break;
                case HYInterestTagCategory:
                    if ([item.businessType isEqualToString:BusinessType_Mall])
                    {
                        HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:item.url];
                        req.searchType = @"20";
                        
                        HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
                        vc.title = item.name;
                        vc.getSearchDataReq = req;
                        
                        [self.baseViewController setTabbarShow:NO];
                        [self.navigationController pushViewController:vc
                                                             animated:YES];
                        
                        [HYAnalyticsManager sendProductListVisitWithBannerItem:item
                                                                         board:board
                                                                      fromPage:1
                                                                         stgid:self.stgId];
                        /// 商品详情统计插码
                        [[HYAnalyticsManager sharedManager] beginProductDetailFromHomeWithItem:item board:board];
                    }
                    else
                    {
                        [self.baseViewController setTabbarShow:NO];
                        
                        HYFlowerSubListViewController* vc = [[HYFlowerSubListViewController alloc]init];
                        vc.categoryID = item.productId;
                        vc.categoryName = item.name;
                        [self.navigationController pushViewController:vc
                                                             animated:YES];
                    }
                    break;
                    
                case HYInterestTagGetMoneyType:  //赚现金券，需要判断item.code
                    [self didSelectEarnCashTicketCode:item.code];
                    break;
                case HYInterestTagShake:
                {
                    [self checkLogin:^{
                        
                        [self.baseViewController setTabbarShow:NO];
                        HYShakeViewController *vc = [[HYShakeViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                }
                    break;
                case HYInterestTagSwipe:
                {
                    [self.baseViewController setTabbarShow:NO];
                    HYScannerViewController *vc = [[HYScannerViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
            return;
        }
        
        /// 热点区域统计
        [[HYAnalyticsManager sharedManager] hotStaticsWithB:homeBoard.boardCode
                                                         b2:item.bannerCode
                                                          t:item.type
                                                       from:1];
        
        switch (item.itemType)
        {
            case MallHomeItemWeb:  //url
            {
                PTHttpManager *mg = [PTHttpManager getInstantane];
                NSString *pasedURL = [mg signWithURL:item.url];
                if (pasedURL) {
                    HYMallWebViewController *vc = [[HYMallWebViewController alloc] init];
                    vc.title = item.name;
                    vc.linkUrl = pasedURL;
                    [self.baseViewController setTabbarShow:NO];
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
                
                //统计
                [HYAnalyticsManager sendWebVisitReqWithURL:item.url];
            }
                break;
            case MallHomeItemStore:
            case MallHomeItemSearch:
            case MallHomeItemBrand:
            {
                HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:item.url];
                if (item.itemType == MallHomeItemStore) {
                    req.searchType = @"10";
                } else if (item.itemType == MallHomeItemSearch) {
                    req.searchType = @"10";
                } else {
                    req.searchType = @"30";
                }
                
                HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
                vc.title = item.name;
                vc.getSearchDataReq = req;
                
                [self.baseViewController setTabbarShow:NO];
                [self.navigationController pushViewController:vc
                                                     animated:YES];
                
                /// 列表页插码
                [HYAnalyticsManager sendProductListVisitWithBannerItem:item board:board
                                                              fromPage:1
                                                                 stgid:self.stgId];
                /// 商品详情统计插码
                [[HYAnalyticsManager sharedManager] beginProductDetailFromHomeWithItem:item board:board];
                
            }
                break;
            case MallHomeItemCategory:
            {
                if ([item.businessType isEqualToString:BusinessType_Mall])
                {
                    HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithParamStr:item.url];
                    req.searchType = @"20";
                    
                    HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
                    vc.title = item.name;
                    vc.getSearchDataReq = req;
                    
                    [self.baseViewController setTabbarShow:NO];
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                    
                    [HYAnalyticsManager sendProductListVisitWithBannerItem:item
                                                                     board:board
                                                                  fromPage:1
                                                                     stgid:self.stgId];
                    /// 商品详情统计插码
                    [[HYAnalyticsManager sharedManager] beginProductDetailFromHomeWithItem:item board:board];
                }
                else
                {
                    [self.baseViewController setTabbarShow:NO];
                    
                    HYFlowerSubListViewController* vc = [[HYFlowerSubListViewController alloc]init];
                    vc.categoryID = item.productId;
                    vc.categoryName = item.name;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
            }
                break;
            case MallHomeItemGoods: //商品详情
            {
                if ([item.businessType isEqualToString:BusinessType_Mall])
                {
                    [self.baseViewController setTabbarShow:NO];
                    HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
                    vc.goodsId =  item.productId;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                    
                    [[HYAnalyticsManager sharedManager] beginProductDetailFromHomeWithItem:item board:board];
                }
                else if ([item.businessType isEqualToString:BusinessType_Flower])
                {
                    [self.baseViewController setTabbarShow:NO];
                    
                    HYFlowerDetailViewController* vc = [[HYFlowerDetailViewController alloc]init];
                    vc.produceID = item.productId;
                    vc.title = item.name;
                    vc.headImgUrl = item.pictureUrl;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
            }
                break;
            case MallHomeItemActive: //活动商品列表
            {
                if ([item.businessType isEqualToString:BusinessType_Mall])
                {
                    [self.baseViewController setTabbarShow:NO];
                    
                    HYActivityGoodsRequest *req = [[HYActivityGoodsRequest alloc] initReqWithParamStr:item.url];
                    
                    HYActivityProductListViewController *list = [[HYActivityProductListViewController alloc] init];
                    list.getDataReq = req;
                    list.title = item.name;
                    [self.navigationController pushViewController:list animated:YES];
                    
                    /// 活动分类统计插码
                    [HYAnalyticsManager sendProductListVisitWithBannerItem:item
                                                                     board:board
                                                                  fromPage:1
                                                                     stgid:self.stgId];
                    /// 商品详情统计插码
                    [[HYAnalyticsManager sharedManager] beginProductDetailFromHomeWithItem:item board:board];
                }
                else if ([item.businessType isEqualToString:BusinessType_Flower])
                {
                    [self.baseViewController setTabbarShow:NO];
                    
                    HYActivityGoodsRequest *req = [[HYActivityGoodsRequest alloc] initReqWithParamStr:item.url];
                    
                    HYFlowerSubListViewController* vc = [[HYFlowerSubListViewController alloc]init];
                    vc.getActiveDataReq = req;
                    vc.title = item.name;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
                
                break;
            }
            case MallHomeItemNew:
            case MallHomeItemHot:
            {
                HYActivityGoodsRequest *req = [[HYActivityGoodsRequest alloc] initReqWithParamStr:item.url];
                
                HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
                vc.title = item.name;
                vc.showRecommendGoods = YES;
                vc.getActiveDataReq = req;
                [self.baseViewController setTabbarShow:NO];
                [self.navigationController pushViewController:vc
                                                     animated:YES];
                [HYAnalyticsManager sendProductListVisitWithBannerItem:item
                                                                 board:board
                                                              fromPage:1
                                                                 stgid:self.stgId];
                /// 商品详情统计插码
                [[HYAnalyticsManager sharedManager] beginProductDetailFromHomeWithItem:item board:board];
            }
                break;
            case MallHomeItemShowHands:
            {
                [[HYAppDelegate sharedDelegate] checkLogin:^(BOOL success) {
                    PTHttpManager *mg = [PTHttpManager getInstantane];
                    NSString *parsedURL = [mg signWithURL:item.url];
                    if (parsedURL) {
                        HYShowHandViewController *vc = [[HYShowHandViewController alloc] init];
                        vc.title = item.name;
                        vc.linkUrl = parsedURL;
                        [self.baseViewController setTabbarShow:NO];
                        [self.navigationController pushViewController:vc
                                                             animated:YES];
                    }
                    
                    //统计
                    [HYAnalyticsManager sendWebVisitReqWithURL:item.url];
                }];
            }
                break;
            case MallHomeItemChannel:
            {
                HYChannelViewController *vc = [[HYChannelViewController alloc] init];
                [self.baseViewController setTabbarShow:NO];
                vc.channelCode = item.channelCode;
                vc.channelName = item.name;
                [self.navigationController pushViewController:vc animated:YES];
                
                //统计
                [HYAnalyticsManager sendProductListVisitWithBannerItem:item
                                                                 board:board
                                                              fromPage:1
                                                                 stgid:self.stgId];
            }
                break;
            case MallHomeItemSeckill:
            {
                [[HYAppDelegate sharedDelegate] checkLogin:^(BOOL success) {
                    HYSecondKillViewController *vc = [[HYSecondKillViewController alloc] init];
                    
                    vc.name = item.name;
                    [self.baseViewController setTabbarShow:NO];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    //统计
                    HYVisitObjectReq *ayReq = [[HYVisitObjectReq alloc] init];
                    ayReq.obj_code = item.channelCode;
                    ayReq.obj_type = @"5";
                    [ayReq sendReuqest:nil];
                }];
                break;
            }
            case MallHomeItemEarnTicket:
            {
                [self didSelectEarnCashTicketCode:item.code];
                break;
            }
            default:
                break;
        }
    }
    else if ([product isKindOfClass:[HYProductListSummary class]])
    {
        [self.baseViewController setTabbarShow:NO];
        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
        vc.goodsId = [(HYProductListSummary *)product productId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 * 通过首页跳转到赚现金券业务
 */
- (void)didSelectEarnCashTicketCode:(NSString *)code
{
    [self.baseViewController setTabbarShow:NO];
    
    if ([code isEqualToString:BusinessType_Flight])
    {
        HYFlightSearchViewController *vc = [[HYFlightSearchViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([code isEqualToString:BusinessType_Hotel])
    {
        HYHotelMainViewController *vc = [[HYHotelMainViewController alloc] init];
        vc.navbarTheme = HYNavigationBarThemeBlue;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([code isEqualToString:BusinessType_Flower])
    {
        [self checkLogin:^{
            HYFlowerMainViewController *vc = [[HYFlowerMainViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    else if ([code isEqualToString:BusinessType_O2O_QRScan]) {
        HYQRCodeEncoderViewController *vc = [[HYQRCodeEncoderViewController alloc] init];
        vc.showBottom = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent
                                                    animated:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([code isEqualToString:BusinessType_Yangguang]) {
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid)
        {
            HYCIBaseInfoViewController *webBrowser = [[HYCIBaseInfoViewController alloc] init];
            [self.navigationController pushViewController:webBrowser animated:YES];
        }
        else
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
    }
    else if ([code isEqualToString:BusinessType_Meituan])
    {
        [self checkLogin:^{
            HYMeituanViewController *webBrowser = [[HYMeituanViewController alloc] init];
            webBrowser.showsURLInNavigationBar = NO;
            webBrowser.tintColor = [UIColor whiteColor];
            webBrowser.showsPageTitleInNavigationBar = NO;
            webBrowser.title = @"团购";
            webBrowser.type = Meituan;
            [self.navigationController pushViewController:webBrowser animated:YES];
            
            HYUserInfo *user = [HYUserInfo getUserInfo];
            NSString *url = [NSString stringWithFormat:@"http://r.union.meituan.com/url/visit/?a=1&key=RuMI8Vh70pQsPn5mKiw1F4E9erHYbOdJ&sid=%@&url=http%%3A%%2F%%2Fi.meituan.com", user.userId];
            [webBrowser loadURL:[NSURL URLWithString:url]];
        }];
    }
    else if ([code isEqualToString:BusinessType_DidiTaxi])
    {
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid)
        {
            HYCallTaxiViewController *vc = [[HYCallTaxiViewController alloc]
                                            initWithNibName:@"HYCallTaxiViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
    }
    else if ([code isEqualToString:BusinessType_MeiQiqi])
    {
        
        HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
        webBrowser.type = MeiWeiQiQi;
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
    /// 话费充值入口点
    else if ([code isEqualToString:BusinessType_PhoneCharge])
    {
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
        if (login)
        {
            HYPhoneChargeViewController *vc = [[HYPhoneChargeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
    }
    /// 电影票入口点
    else if ([code isEqualToString:BusinessType_MovieTicket])
    {
        [self checkLogin:^{
            
            HYMeituanViewController *webBrowser = [[HYMeituanViewController alloc] init];
            webBrowser.showsURLInNavigationBar = NO;
            webBrowser.tintColor = [UIColor whiteColor];
            webBrowser.showsPageTitleInNavigationBar = NO;
            webBrowser.title = @"电影票";
            webBrowser.type = MovieTicket;
            [self.navigationController pushViewController:webBrowser animated:YES];
        }];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    HYMallSearchViewController *search = [[HYMallSearchViewController alloc]
                                          initWithNibName:@"HYMallSearchViewController"
                                                                                      bundle:nil];
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}

- (void)brandBoostWillCheckMore
{
    HYMallMoreGoodsRequest *req = [[HYMallMoreGoodsRequest alloc] init];
    req.boardCode = self.viewModel.especialCheap.boardCode;
    
    HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
    vc.showRecommendGoods = YES;
    vc.title = self.viewModel.especialCheap.title;
    vc.getMoreGoodsReq = req;
    vc.style = ProductListStyleRowCell;
    
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
