//
//  HYUpgradeAlertViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBenefitViewController.h"
#import "HYUpdateToOfficialUserViewController.h"
#import "HYUpgradeAlertView.h"
#import "HYUserService.h"
#import "HYPaymentViewController.h"
#import "HYSiRedPacketsViewController.h"
#import "HYUmengLoginClick.h"

@interface HYBenefitViewController ()
<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) HYUserService *userService;

@end

@implementation HYBenefitViewController

- (HYUserService *)userService
{
    if (!_userService) {
        _userService = [[HYUserService alloc] init];
    }
    return _userService;
}

- (void)loadView
{
    CGRect frame = ScreenRect;
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    
    frame.size.height -= 54;
    UIWebView *web = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:web];
    self.webView  = web;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"会员权益";
    NSString *urlString = @"http://m.teshehui.com/index.php?app=users&act=welfare";
    NSURL *URL = [NSURL URLWithString:urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    self.webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, CGRectGetWidth(self.view.frame), 44)];
    footview.backgroundColor = [UIColor whiteColor];
    
    UIImage *disable = [[UIImage imageNamed:@"btn_login_new_disable"] stretchableImageWithLeftCapWidth:3 topCapHeight:5];
    UIImage *normal = [UIImage imageNamed:@"btn_login_new"];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:
                          CGRectMake(24, 5, CGRectGetWidth(self.view.frame)-48, 44)];
    [loginBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:disable forState:UIControlStateDisabled];
    [loginBtn setTitle:@"升级为付费会员" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:loginBtn];
    
    [self.view addSubview:footview];
}

- (void)startAction:(UIButton *)btn
{
//    HYMemberUpgradeViewController *vc = [[HYMemberUpgradeViewController alloc] init];
    
    
    HYUpgradeAlertView *alert = [[HYUpgradeAlertView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
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
                     payVC.productDesc = [NSString stringWithFormat:@"【特奢汇】在线购卡: %@", response.orderNumber]; //商品描述
                     
                     [weakSelf.navigationController pushViewController:payVC animated:YES];
                     payVC.paymentCallback = ^(HYPaymentViewController *payvc, id data)
                     {
                         [payvc.navigationController popToRootViewControllerAnimated:YES];
                         
                         HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
                         vc.cashCard = @"1000";
                         [weakSelf presentViewController:vc animated:YES completion:nil];
                     };
                 }
             }];
        }
        else if (buttonIndex == 1)
        {
            //升级会员
            HYUpdateToOfficialUserViewController *vc = [HYUpdateToOfficialUserViewController new];
            //            HYMemberUpgradeViewController *vc = [[HYMemberUpgradeViewController alloc] init];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
