//
//  HYScannerViewController.m
//  Teshehui
//
//  Created by HYZB on 16/4/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYScannerViewController.h"
#import "HYScannerBtn.h"
#import "QRCodeEncoderViewController.h"
#import "HYQRCodeReaderViewController.h"
#import "HYAppDelegate.h"


@interface HYScannerViewController ()

@end

@implementation HYScannerViewController

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    
    HYScannerBtn *scannerBtn = [HYScannerBtn buttonWithImage:@"icon_scanner"
                                                       title:@"扫一扫"];
    scannerBtn.frame = CGRectMake(TFScalePoint(10), TFScalePoint(10),
                                  TFScalePoint(300), 200);
    [scannerBtn addTarget:self action:@selector(scannerBtnAction)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scannerBtn];
    
    HYScannerBtn *quickBuyBtn = [HYScannerBtn buttonWithImage:@"icon_scanner_quickbuy"
                                                        title:@"快速买单"];
    quickBuyBtn.frame = CGRectMake(TFScalePoint(10),
                                   CGRectGetMaxY(scannerBtn.frame)+TFScalePoint(10),
                                   TFScalePoint(300), 200);
    [quickBuyBtn addTarget:self action:@selector(quickBuyBtnAction)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quickBuyBtn];
}

#pragma mark - privateMethod
- (void)scannerBtnAction
{
    //扫一扫
    [MobClick event:@"v430_shangcheng_shouye_gengduo_saoyisao_jishu"];
    
    BOOL _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!_isLogin)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
    else
    {
        [self.baseViewController setTabbarShow:NO];
        HYQRCodeReaderViewController *vc = [[HYQRCodeReaderViewController alloc] init];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (void)quickBuyBtnAction
{
    //快速买单
    [MobClick event:@"v430_shangcheng_shouye_gengduo_kuaisumaidan_jishu"];
    
    [self.baseViewController setTabbarShow:NO];
    QRCodeEncoderViewController *vc = [[QRCodeEncoderViewController alloc] init];
    vc.showBottom = NO;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
