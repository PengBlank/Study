   //
//  CQBaseViewController.m
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "HYTabbarViewController.h"
#import "HYNavigationController.h"

#import "HYAroundMallListViewController.h"
#import "HYMineInfoViewController.h"
#import "HYAppDelegate.h"

#import "HYMallHomeViewController.h"
#import "HYMallCartViewController.h"
//#import "HYEarnTicketViewController.h"
#import "HYEarnCashTicketViewController.h"

#import "HYMyDesireDetailViewController.h"
#import "HYSecondKillViewController.h"
#import "HYStartAdsDataController.h"
#import "HYMallHomeBoard.h"
#import "SDWebImageManager.h"

//更新
#import "HYCategoryViewController.h"
#import "HYPageViewController.h"
#import "HYTabbarBaseView.h"
#import "HYTabbarItem.h"
#import "HYMallHomeItem.h"
#import "HYShoppingCarView.h"
#import "UIImage+Addition.h"
#import "UIColor+hexColor.h"
#import "NSString+Addition.h"
#import "NSDate+Addition.h"
#import "HYStartAdsViewController.h"
#import "HYInterestSelectViewController.h"

//#import "BusinessRootCtrl.h"
//#import "BusinessMapViewController.h"
#import "BusinessMainViewController.h"
#import "HYUserInfo.h"
#import "HYShakeViewController.h"


extern NSString * const ShowMoreTypeViewNotification;

@interface HYTabbarViewController ()
<
CQBaseNavViewControllerDelegate,
HYTabbarBaseViewDelegate
>
{
    BOOL _isShare;
    BOOL _showTabbar;
    HYTabbarBaseView *_tabbar;
    NSUInteger _activeIndex;
}

@property (nonatomic, strong) HYMallHomeItem *item;//用于广告跳转的item
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) HYMallHomeViewController *homeViewController;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) NSArray *viewControllers;

@end

@implementation HYTabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isShare = NO;
        _activeIndex = 0;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    if (!CheckIOS7)
    {
        frame.size.height -= 20;
    }
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (!self.viewControllers)
    {
        self.homeViewController = [[HYMallHomeViewController alloc] init];
        self.homeViewController.item = self.item;
        self.homeViewController.baseViewController = self;
        HYNavigationController *navHome = [[HYNavigationController alloc] initWithRootViewController:self.homeViewController];
        
        //O2O商户
//        BusinessRootCtrl *O2OStoreVC = [[BusinessRootCtrl alloc] init];
//        O2OStoreVC.baseViewController = self;
//        HYNavigationController *navO2O = [[HYNavigationController alloc] initWithRootViewController:O2OStoreVC];
        
        BusinessMainViewController *O2OStoreVC = [[BusinessMainViewController alloc] init];
        O2OStoreVC.baseViewController = self;
        HYNavigationController *navO2O = [[HYNavigationController alloc] initWithRootViewController:O2OStoreVC];
        
        
        //现金券
//        HYEarnTicketViewController *earn = [[HYEarnTicketViewController alloc] init];
//        earn.baseViewController = self;
//        HYNavigationController *navEarn = [[HYNavigationController alloc] initWithRootViewController:earn];
        HYEarnCashTicketViewController *earn = [[HYEarnCashTicketViewController alloc] init];
        earn.baseViewController = self;
        HYNavigationController *navEarn = [[HYNavigationController alloc] initWithRootViewController:earn];
        
        //我
        HYMineInfoViewController *mineVC = [[HYMineInfoViewController alloc] init];
        mineVC.baseViewController = self;
        HYNavigationController *navMine = [[HYNavigationController alloc] initWithRootViewController:mineVC];
        
        self.viewControllers = [NSArray arrayWithObjects:navHome, navO2O, navEarn, navMine, nil];
        
        self.currentViewController = navHome;
        [self.view addSubview:navHome.view];
    }
    
    if (!_tabbar)
    {
        CGFloat oring_y = self.view.frame.size.height-TFScalePoint(kTabBarHeight);
        _tabbar = [[HYTabbarBaseView alloc] initWithFrame:CGRectMake(0,
                                                                     oring_y,
                                                                     self.view.frame.size.width,
                                                                     TFScalePoint(kTabBarHeight))];
        _tabbar.backgroundColor = [UIColor clearColor];
        _tabbar.normalColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0f];
        _tabbar.selectedColor = [UIColor colorWithHexColor:@"AD1F24"
                                                     alpha:1.0];
        _tabbar.backgroudImage = [UIImage imageNamed:@"store_bg_tab"];
        _tabbar.delegate = self;
        if ([self timeIsInNewYear]) {
//        if (false) {
            [self initTabbarItemsForNewyear];
        }
        else {
            [self initTabbarItems];
        }
        
        [_tabbar setItems:self.items];
        
        [self.view addSubview:_tabbar];
    }
    
    
    //处理广告和标签
    WS(weakSelf);
    [self showAdsWithCallback:^{
        [weakSelf showInterest];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark pulice methods
- (void)updateTitleView
{
    if (_activeIndex == 0)
    {
        UIImage *image = [UIImage imageNamed:@"navtitleview_logo"];
        UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
        titleView.image = image;
        self.navigationItem.titleView = titleView;
    }
    else
    {
        if ([self.navigationItem.titleView isKindOfClass:[UILabel class]])
        {
            if (_activeIndex < [self.viewControllers count])
            {
                UIViewController *vc = [self.viewControllers objectAtIndex:_activeIndex];
                [(UILabel *)self.navigationItem.titleView setText:vc.title];
            }
        }
        else
        {
            UILabel *t = [[UILabel alloc] initWithFrame:TFRectMake(0, 0, 160, 30)];
            t.textColor =  [UIColor colorWithRed:161.0/255.0
                                           green:0
                                            blue:0
                                           alpha:1.0];
            t.font = [UIFont systemFontOfSize:19];
            t.backgroundColor = [UIColor clearColor];
            t.textAlignment = NSTextAlignmentCenter;
            
            if (_activeIndex < [self.viewControllers count])
            {
                UIViewController *vc = [self.viewControllers objectAtIndex:_activeIndex];
                t.text = vc.title;
            }
            
            self.navigationItem.titleView = t;
        }
    }
}

- (void)setTabbarShow:(BOOL)show
{
    if (_showTabbar != show)
    {
        _showTabbar = show;
        
        if (show)
        {
            BOOL has = [[NSUserDefaults standardUserDefaults] boolForKey:kShoppingCarHasNew];
            [self setStatus:has atIndex:3];
            
            __weak HYTabbarBaseView *b_tabbar = _tabbar;
            CGRect rect = _tabbar.frame;
            rect.origin.y = self.view.frame.size.height-rect.size.height;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 b_tabbar.frame = rect;
                             }];
        }
        else
        {
            __weak HYTabbarBaseView *b_tabbar = _tabbar;
            CGRect rect = _tabbar.frame;
            rect.origin.y = self.view.frame.size.height;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 b_tabbar.frame = rect;
                             }];
        }
    }
}

- (void)handleRemoteNotifionInfo
{
    NSDictionary *remoteNotifyInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kRemoteNotificationUserInfo];
    
    if (remoteNotifyInfo)
    {
        NSString *type = [remoteNotifyInfo objectForKey:@"type_code"];
        NSString *content = [remoteNotifyInfo objectForKey:@"type_content"];
        
        HYMallHomeItem *item = nil;
        switch ([type intValue]) {
            case 1://普通
                break;
            case 2://抽奖活动
            {
                NSDictionary *dic = [content urlParamToDic];
                NSString *url = [dic objectForKey:@"url"];
                NSString *title = [dic objectForKey:@"title"];
                
                if (url)
                {
                    item = [[HYMallHomeItem alloc] init];
                    item.itemType = MallHomeItemWeb;
                    item.url = url;
                    item.name = title;
                }
                else
                {
                    item = [[HYMallHomeItem alloc] init];
                    item.itemType = MallHomeItemShowHands;
                    item.name = title;
                }
            }
                break;
            case 3://店铺
            {
                NSDictionary *dic = [content urlParamToDic];
                NSString *storeId = [dic objectForKey:@"store_id"];
                NSString *title = [dic objectForKey:@"title"];
                
                if (storeId && title)
                {
                    NSString *url = [NSString stringWithFormat:@"expandedRequest={storeId:%@}", storeId];
                    item = [[HYMallHomeItem alloc] init];
                    item.itemType = MallHomeItemStore;
                    item.url = url;
                    item.name = title;
                }
            }
                break; 
            case 4://搜索
            {
                NSDictionary *dic = [content urlParamToDic];
                NSString *keyword = [dic objectForKey:@"keyword"];
                NSString *title = [dic objectForKey:@"title"];
                
                if (keyword && title)
                {
                    NSString *url = [NSString stringWithFormat:@"keyword=%@", keyword];
                    item = [[HYMallHomeItem alloc] init];
                    item.itemType = MallHomeItemSearch;
                    item.url = url;
                    item.name = title;
                }
            }
                break;
            case 5://分类
            {
                NSDictionary *dic = [content urlParamToDic];
                NSString *categoryId = [dic objectForKey:@"category_id"];
                NSString *title = [dic objectForKey:@"title"];
                
                if (categoryId && title)
                {
                    NSString *url = [NSString stringWithFormat:@"expandedRequest={categoryId:%@}", categoryId];
                    item = [[HYMallHomeItem alloc] init];
                    item.itemType = MallHomeItemCategory;
                    item.businessType = BusinessType_Mall;
                    item.url = url;
                    item.name = title;
                }
            }
                break;
            case 6://商品店铺活动
            {
                NSDictionary *dic = [content urlParamToDic];
                NSString *brandId = [dic objectForKey:@"boardCode"];
                NSString *title = [dic objectForKey:@"title"];
                
                if (brandId && title)
                {
                    NSString *url = [NSString stringWithFormat:@"activityCode=%@", brandId];
                    item = [[HYMallHomeItem alloc] init];
                    item.itemType = MallHomeItemActive;
                    item.businessType = BusinessType_Mall;
                    item.url = url;
                    item.name = title;
                }
            }
                break;
            case 7://商品
            {
                NSDictionary *dic = [content urlParamToDic];
                NSString *goodsId = [dic objectForKey:@"goods_id"];
                NSString *title = [dic objectForKey:@"title"];
                
                if (goodsId && title)
                {
                    item = [[HYMallHomeItem alloc] init];
                    item.itemType = MallHomeItemGoods;
                    item.businessType = BusinessType_Mall;
                    item.productId = goodsId;
                    item.name = title;
                }
            }
                break;
            case 8:// 帮我买详情
            {
                
                NSDictionary *dic = [content urlParamToDic];
                NSString *wishId = [dic objectForKey:@"wishId"];
                
                __weak typeof(self) b_self = self;
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   if (b_self)
                                   {
                                       
                                       HYTabbarViewController *s_self = b_self;
                                       //                    [s_self popToRootViewControllerAnimated:YES];
                                       if (![HYUserInfo getUserInfo].userId) {
                                           [s_self setCurrentSelectIndex:3 animated:NO];
                                           return;
                                       } else {
                                           [s_self setCurrentSelectIndex:0 animated:NO];
                                       }
                                   }
                                   dispatch_async(dispatch_get_main_queue(), ^
                                                  {
                                                      HYMyDesireDetailViewController *myDesireDetailVC = [[HYMyDesireDetailViewController alloc] init];
                                                      myDesireDetailVC.desireId = [wishId integerValue];
                                                     // [b_self.homeViewController checkProductDetail:item];
                                                      [b_self setTabbarShow:NO];
                                                  [b_self.homeViewController.navigationController pushViewController:myDesireDetailVC animated:YES];
                                                  });
                               });
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRemoteNotificationUserInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                return;
            }
                break;
            case 9:
            {
                [self setTabbarShow:NO];
                NSDictionary *dic = [content urlParamToDic];
                NSString *wishId = [dic objectForKey:@"activityId"];
                HYSecondKillViewController *kill = [[HYSecondKillViewController alloc] init];
                kill.activityId = wishId;
                [self setCurrentSelectIndex:0 animated:NO];
                UINavigationController *nav = [[self viewControllers] objectAtIndex:0];
                [nav popToRootViewControllerAnimated:NO];
                [nav pushViewController:kill animated:YES];
                break;
            }
            case 10:
            {
                NSDictionary *dic = [content urlParamToDic];
                NSString *brand_code = [dic objectForKey:@"brand_code"];
                NSString *title = [dic objectForKey:@"title"];
                
                if (brand_code && title)
                {
                    NSString *url = [NSString stringWithFormat:@"expandedRequest={\"brandId\":[\"%@\"]}", brand_code];
                    item = [[HYMallHomeItem alloc] init];
                    item.itemType = MallHomeItemBrand;
                    item.url = url;
                    item.name = title;
                }
                break;
            }
            default:
                break;
        }
        
        if (item) {
            [self setCurrentSelectIndex:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:kHomeRouteNotification
                                                                object:item];
        }
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRemoteNotificationUserInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)handleLocalNotifcation
{
    BOOL _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (_isLogin)
    {
        for (HYNavigationController *nav in self.viewControllers)
        {
            [nav popToRootViewControllerAnimated:NO];
        }
        [self setCurrentSelectIndex:0];
        HYShakeViewController *vc = [[HYShakeViewController alloc] init];
        HYNavigationController *mineNav = self.viewControllers[0];
        [mineNav pushViewController:vc animated:YES];
        [self setTabbarShow:NO];
    }
    else
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
}

#pragma mark private methods
- (void)initTabbarItems
{
    NSMutableArray *muItems = [[NSMutableArray alloc] init];
    
    HYTabbarItem *home = [[HYTabbarItem alloc] init];
    home.title = @"商城";
    home.normalImage = [UIImage imageWithNamedAutoLayout:@"dh_1"];
    home.selectImage = [UIImage imageWithNamedAutoLayout:@"dh_1_on"];
    home.index = 0;
    [muItems addObject:home];
    
//    HYTabbarItem *brand = [[HYTabbarItem alloc] init];
//    brand.title = @"品类";
//    brand.normalImage = [UIImage imageWithNamedAutoLayout:@"f_2"];
//    brand.selectImage = [UIImage imageWithNamedAutoLayout:@"f_2_on"];
//    brand.index = 1;
//    [muItems addObject:brand];
    
    HYTabbarItem *order = [[HYTabbarItem alloc] init];
    order.title = @"附近优惠";
    order.normalImage = [UIImage imageWithNamedAutoLayout:@"dh_2"];
    order.selectImage = [UIImage imageWithNamedAutoLayout:@"dh_2_on"];
    order.index = 1;
    [muItems addObject:order];
    
    HYTabbarItem *type = [[HYTabbarItem alloc] init];
    type.title = @"赚现金券";
    type.normalImage = [UIImage imageWithNamedAutoLayout:@"dh_3"];
    type.selectImage = [UIImage imageWithNamedAutoLayout:@"dh_3_on"];
    type.index = 2;
    [muItems addObject:type];
    
    HYTabbarItem *mine = [[HYTabbarItem alloc] init];
    mine.title = @"我";
    mine.normalImage = [UIImage imageWithNamedAutoLayout:@"dh_4"];
    mine.selectImage = [UIImage imageWithNamedAutoLayout:@"dh_4_on"];
    mine.index = 3;
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    BOOL hasNew = [[NSUserDefaults standardUserDefaults] boolForKey:kIsShowRedpacket];
    if (isLogin && !hasNew)
    {
        mine.hasNew = YES;
    }
    
    [muItems addObject:mine]; 
    
    self.items = [muItems copy];
}

- (void)initTabbarItemsForNewyear
{
    _tabbar.backgroundColor = [UIColor colorWithWhite:.2 alpha:1];
    _tabbar.backgroudImage = nil;
    
    NSMutableArray *muItems = [[NSMutableArray alloc] init];
    
    HYTabbarItem *home = [[HYTabbarItem alloc] init];
    home.normalImage = [UIImage imageWithNamedAutoLayout:@"tabnewyear_1"];
    home.selectImage = [UIImage imageWithNamedAutoLayout:@"tabnewyear_1_1"];
    home.index = 0;
    [muItems addObject:home];
    
    //    HYTabbarItem *brand = [[HYTabbarItem alloc] init];
    //    brand.title = @"品类";
    //    brand.normalImage = [UIImage imageWithNamedAutoLayout:@"f_2"];
    //    brand.selectImage = [UIImage imageWithNamedAutoLayout:@"f_2_on"];
    //    brand.index = 1;
    //    [muItems addObject:brand];
    
    HYTabbarItem *order = [[HYTabbarItem alloc] init];
    order.normalImage = [UIImage imageWithNamedAutoLayout:@"tabnewyear_2"];
    order.selectImage = [UIImage imageWithNamedAutoLayout:@"tabnewyear_2_1"];
    order.index = 1;
    [muItems addObject:order];
    
    HYTabbarItem *type = [[HYTabbarItem alloc] init];
    type.normalImage = [UIImage imageWithNamedAutoLayout:@"tabnewyear_3"];
    type.selectImage = [UIImage imageWithNamedAutoLayout:@"tabnewyear_3_1"];
    type.index = 2;
    [muItems addObject:type];
    
    HYTabbarItem *mine = [[HYTabbarItem alloc] init];
    mine.normalImage = [UIImage imageWithNamedAutoLayout:@"tabnewyear_4"];
    mine.selectImage = [UIImage imageWithNamedAutoLayout:@"tabnewyear_4_1"];
    mine.index = 3;
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    BOOL hasNew = [[NSUserDefaults standardUserDefaults] boolForKey:kIsShowRedpacket];
    if (isLogin && !hasNew)
    {
        mine.hasNew = YES;
    }
    
    [muItems addObject:mine];
    
    self.items = [muItems copy];
}

/// 判断是否是过年，显示新的tabbar item
/// 2016-02-07 00:00:00 - 2016-02-14 23:59:59
- (BOOL)timeIsInNewYear
{
    NSDate *date = [NSDate date];
    NSDate *dateBegin = [NSDate dateFromString:@"2016-02-07 00:00:00" withFormate:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateEnd = [NSDate dateFromString:@"2016-02-14 23:59:59" withFormate:@"yyyy-MM-dd HH:mm:ss"];
    if ([date compare:dateBegin] == NSOrderedDescending &&
        [date compare:dateEnd] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

- (NSUInteger)indexForViewController:(UIViewController *)viewController
{
    return [self.viewControllers indexOfObject:viewController];
}

- (void)setCurrentSelectIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index != _activeIndex)
    {
        UIViewController *vc = [self.viewControllers objectAtIndex:index];
        if (vc != self.currentViewController)
        {
            if([_currentViewController presentedViewController] != nil)
                [_currentViewController dismissViewControllerAnimated:NO
                                                           completion:nil];
            
        	[_currentViewController viewWillDisappear:NO];
            [[_currentViewController view] removeFromSuperview];
            [_currentViewController viewDidDisappear:NO];
            
            self.currentViewController = vc;
            
            [_currentViewController viewWillAppear:NO];
            [self.view insertSubview:vc.view
                        belowSubview:_tabbar];
            [_currentViewController viewDidAppear:NO];
        }
        
        _activeIndex = index;
        [_tabbar setSelectedItemIndex:index];
        [self updateTitleView];
    }
}

- (void)setCurrentSelectIndex:(NSInteger)index
{
    [self setCurrentSelectIndex:index animated:YES];
}

- (void)setStatus:(BOOL)hasNew atIndex:(NSInteger)index
{
    if (index < [self.items count])
    {
        HYTabbarItem *item = [self.items objectAtIndex:index];
        item.hasNew = hasNew;
        [_tabbar setNeedsDisplay];
    }
}

#pragma mark - HYTabbarBaseViewDelegate
- (void)updateWithDoubleClick:(HYTabbarItem *)tabbarItem
{
    if (tabbarItem.index < [self.viewControllers count])
    {
        UIViewController *vc = [self.viewControllers objectAtIndex:tabbarItem.index];
        if ([vc isKindOfClass:[HYMallHomeViewController class]])
        {
            HYMallHomeViewController *mallMianVC = (HYMallHomeViewController *)vc;
            [mallMianVC reloadAllData];
        }
    }
}

- (void)didChangeTabbarItem:(HYTabbarItem *)tabbarItem
{
    if (_activeIndex!=tabbarItem.index && tabbarItem.index < [self.viewControllers count])
    {
        [self setCurrentSelectIndex:tabbarItem.index];
    }
}

#pragma mark - CQBaseNavViewControllerDelegate
- (UIImage *)captureScreen
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [[UIScreen mainScreen] scale]); //Retina support
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (HYTabbarViewController *)sharedTabbarController
{
    HYAppDelegate *delegate = (HYAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.baseContentView;
}

- (void)showAdsWithCallback:(void (^)(void))callback;
{
    //有缓存则加载广告页面
    NSDictionary *cacheAds = [[NSUserDefaults standardUserDefaults]objectForKey:kStartAdsItem];
    UIImage *cache = nil;
    if (cacheAds)
    {
        cache = [[SDImageCache sharedImageCache]
                 imageFromDiskCacheForKey:kAdsImage];
    }
    
    BOOL from3d = [HYAppDelegate sharedDelegate].isFrom3DTouch;
    
    if (cache && cacheAds && !from3d)
    {
        HYStartAdsViewController *adsView = [[HYStartAdsViewController alloc] init];
        [self.view addSubview:adsView.view];
        [self addChildViewController:adsView];
        
        adsView.startAdsCallback = ^(BOOL skiped) {
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback();
                });
            }
        };
    }
    else
    {
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback();
            });
            
        }
    }
}

- (void)showInterest
{
    BOOL interLabelTStats = [[NSUserDefaults standardUserDefaults] boolForKey:kSettingInterestLabel];
    BOOL from3d = [HYAppDelegate sharedDelegate].isFrom3DTouch;
    if (!interLabelTStats && !from3d)
    {
        HYInterestSelectViewController *interestView = [[HYInterestSelectViewController alloc] init];
        [self presentViewController:interestView
                           animated:YES
                         completion:nil];
        
        WS(weakSelf);
        interestView.didSelectedInterest = ^(BOOL hasChange){
            [weakSelf.homeViewController reloadHomePageWithDataChange:hasChange];
        };
    }
}

@end
