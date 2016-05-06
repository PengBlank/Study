//
//  HYEarnCashTicketViewController.m
//  Teshehui
//
//  Created by HYZB on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYEarnCashTicketViewController.h"
#import "HYUserService.h"
#import "HYUpgradeAlertView.h"
#import "HYUserInfo.h"
#import "HYUpgradeAlertView.h"
#import "HYPaymentViewController.h"
#import "HYEarnCashTicketContentView.h"
#import "HYFlightSearchViewController.h"
#import "HYHotelMainViewController.h"
#import "HYGroupProtocolViewController.h"
#import "HYQRCodeEncoderViewController.h"
#import "HYCIBaseInfoViewController.h"
#import "HYCallTaxiViewController.h"
#import "HYPhoneChargeViewController.h"
#import "HYAppDelegate.h"
#import "HYFlowerMainViewController.h"
#import "HYMeituanViewController.h"



@interface HYEarnCashTicketViewController ()
<HYEarnCashTicketContentViewDelegate>

@property (nonatomic, strong) HYUserService *userService;
@property (nonatomic, strong) HYEarnCashTicketContentView *contentV;

@property (nonatomic, strong) UIScrollView *earnScrollView;

@end

@implementation HYEarnCashTicketViewController

- (HYUserService *)userService
{
    if (!_userService) {
        _userService = [[HYUserService alloc] init];
    }
    return _userService;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= (64);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
    frame.size.height -= TFScalePoint(kTabBarHeight);
    HYEarnCashTicketContentView *contentV = [[HYEarnCashTicketContentView alloc]
                                             initWithFrame:frame];
    _contentV = contentV;
    [self.view addSubview:contentV];
    contentV.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"1:1赚现金券，可以当钱花哦";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.baseViewController setTabbarShow:YES];
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    //体验用户
    BOOL isExperienceUser = (user && user.userLevel == 0);
    if (isExperienceUser)
    {
        _contentV.head.hidden = NO;
    }
    else
    {
        _contentV.head.hidden = YES;
    }
}

#pragma mark - privateMethod

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

#pragma mark - HYEarnCashTicketContentViewDelegate
- (void)didSelectUpgrad
{
    HYUpgradeAlertView *alert = [[HYUpgradeAlertView alloc]
                                 initWithFrame:CGRectMake(0, 0, 240, 100)];
    [alert showWithAnimation:YES];
    alert.handler = ^(NSInteger buttonIndex)
    {
        if (buttonIndex == 0)
        {
            [HYLoadHubView show];
            WS(weakSelf);
            [self.userService upgradeWithNoPolicy:^(HYUserUpgradeResponse *response)
             {
                 [HYLoadHubView dismiss];
                 if (response.status == 200)
                 {
                     HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
                     payVC.navbarTheme = weakSelf.navbarTheme;
                     payVC.amountMoney = response.orderAmount;
                     payVC.orderID = response.orderId;
                     payVC.orderCode = response.orderNumber;
                     payVC.type = Pay_Upgrad;
                     payVC.productDesc = [NSString stringWithFormat:@"【特奢汇】在线购卡: %@",
                                          response.orderNumber]; //商品描述
                     
                     [weakSelf.navigationController pushViewController:payVC animated:YES];
                     [weakSelf.baseViewController setTabbarShow:NO];
                     
                     payVC.paymentCallback = ^(HYPaymentViewController *payvc, id data)
                     {
                         [payvc.navigationController popToRootViewControllerAnimated:YES];
                         [HYSiRedPacketsViewController showWithPoints:@"1000" completeBlock:nil];
                     };
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc]
                                           initWithTitle:@"提示" message:response.suggestMsg
                                           delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alert show];
                 }
             }];
        }
        else if (buttonIndex == 1)
        {
            //升级会员
            HYUpdateToOfficialUserViewController *vc = [HYUpdateToOfficialUserViewController new];
            //            HYMemberUpgradeViewController *vc = [[HYMemberUpgradeViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    };
}

- (void)didSelectWithEarnType:(HYBusinessType *)type
{
    [self.baseViewController setTabbarShow:NO];
    
    if ([type.businessTypeCode isEqualToString:BusinessType_Flight]) {
        HYFlightSearchViewController *vc = [[HYFlightSearchViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_Hotel]) {
        HYHotelMainViewController *vc = [[HYHotelMainViewController alloc] init];
        vc.navbarTheme = HYNavigationBarThemeBlue;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_Flower]) {
        
        [self checkLogin:^{
            HYFlowerMainViewController *vc = [[HYFlowerMainViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_O2O_QRScan]) {
        HYQRCodeEncoderViewController *vc = [[HYQRCodeEncoderViewController alloc] init];
        [self.baseViewController setTabbarShow:NO];
        vc.showBottom = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent
                                                    animated:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_Yangguang]) {
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid)
        {
            HYCIBaseInfoViewController *webBrowser = [[HYCIBaseInfoViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            
            [self.navigationController pushViewController:webBrowser animated:YES];
        }
        else
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_Meituan]) {

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
    else if ([type.businessTypeCode isEqualToString:BusinessType_DidiTaxi]) {
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid)
        {
            HYCallTaxiViewController *vc = [[HYCallTaxiViewController alloc]
                                            initWithNibName:@"HYCallTaxiViewController" bundle:nil];
            [self.baseViewController setTabbarShow:NO];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
    }
    else if ([type.businessTypeCode isEqualToString:BusinessType_MeiQiqi]) {
        
        HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
        webBrowser.type = MeiWeiQiQi;
        [self.baseViewController setTabbarShow:NO];
        
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
    /// 话费充值入口点
    else if ([type.businessTypeCode isEqualToString:BusinessType_PhoneCharge])
    {
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
        if (login)
        {
            HYPhoneChargeViewController *vc = [[HYPhoneChargeViewController alloc] init];
            [self.baseViewController setTabbarShow:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadLoginView];
        }
    }
    /// 电影票入口点
    else if ([type.businessTypeCode isEqualToString:BusinessType_MovieTicket])
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

@end
