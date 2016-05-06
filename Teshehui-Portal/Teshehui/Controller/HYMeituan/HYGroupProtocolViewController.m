//
//  HYGroupProtocolViewController.m
//  Teshehui
//
//  Created by HYZB on 15/4/28.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGroupProtocolViewController.h"
#import "HYMeituanViewController.h"
#import "HYGetProtocolReq.h"
#import "HYUserInfo.h"
#import "HYAppDelegate.h"
#import "HYFlowerMainViewController.h"
#import "HYUpdateToOfficialUserViewController.h"
#import "HYMeiWeiQiQiViewController.h"
#import "HYGetFunctionModuleTipsRequest.h"
#import "HYUpgradeAlertView.h"
#import "NSString+Addition.h"
#import "GTMBase64.h"
#import "HYMovieGetURLRequest.h"
#import "METoast.h"

@interface HYGroupProtocolViewController ()
{
    HYGetProtocolReq *_getProtocolReq;
    HYGetFunctionModuleTipsRequest *_getFunctionModuleTipsReq;
    
    UIView *_aboveContentView;
    UIImageView *_vipUpgradeView;
    UILabel *_vipUpgradeLabel;
    UIImageView *_rightArrow;
    
    UIWebView *_contentView;
    UIButton *_doneBtn;
    UIButton *_upgrade;
    
    //是否显示会员升级的图案
    BOOL _showVipImage;
    
    HYMovieGetURLRequest *_movieURLRequest;
}

@end

@implementation HYGroupProtocolViewController

- (void)dealloc
{
    [_getProtocolReq cancel];
    _getProtocolReq = nil;
    
    [_getFunctionModuleTipsReq cancel];
    _getFunctionModuleTipsReq = nil;
    
    [_movieURLRequest cancel];
    _movieURLRequest = nil;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"温馨提示";
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    //体验会员才显示会员升级图案
    if (0 == userInfo.userLevel && userInfo)
    {
        _showVipImage = YES;
    }
    _showVipImage = NO;
    
    if (!_aboveContentView && _showVipImage)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGRect frame = TFRectMake(0, 0, size.width, 160);
        _aboveContentView = [[UIView alloc]initWithFrame:frame];
        [self.view addSubview:_aboveContentView];
        
        _vipUpgradeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"meituan_top"]];
        _vipUpgradeView.frame = TFRectMake(100, 10, 136, 111);
        [_aboveContentView addSubview:_vipUpgradeView];
        
        _vipUpgradeLabel = [UILabel new];
        _vipUpgradeLabel.frame = TFRectMake(10, 130, 300, 40);
        _vipUpgradeLabel.font = [UIFont systemFontOfSize:TFScalePoint(12.0)];
        NSString *str = @"只有付费会员可以获得等额现金券，您当前是会员，试下成为付费会员获取多多红利吧！";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(22, 4)];
        [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(22, 4)];
        _vipUpgradeLabel.attributedText = attrStr;
        _vipUpgradeLabel.numberOfLines = 0;
        [_aboveContentView addSubview:_vipUpgradeLabel];
        
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"meituan_right"]];
        _rightArrow.frame = TFRectMake(305, 145, 7, 10);
        [_aboveContentView addSubview:_rightArrow];
        
        //立即升级
        _upgrade = [UIButton buttonWithType:UIButtonTypeCustom];
        _upgrade.backgroundColor = [UIColor clearColor];
        _upgrade.frame = TFRectMake(240, 135, 80, 30);
        [_upgrade addTarget:self action:@selector(upgradeImmediately) forControlEvents:UIControlEventTouchUpInside];
        [_aboveContentView addSubview:_upgrade];
    }
    if (!_contentView && _showVipImage)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGRect frame = TFRectMake(10, 160, 300, size.height - TFScalePoint(280));

        _contentView = [[UIWebView alloc] initWithFrame:frame];
        [self.view addSubview:_contentView];
    }
    else
    {
        CGRect frame = self.view.frame;
        frame.size.width -= 20;
        frame.origin.x = 10;
        frame.origin.y += 20;
        frame.size.height -= 60;
        
        _contentView = [[UIWebView alloc] initWithFrame:frame];
        [self.view addSubview:_contentView];
    }
    
    if (!_doneBtn)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setBackgroundImage:[UIImage imageNamed:@""]
                            forState:UIControlStateNormal];
        
        _doneBtn.frame = CGRectMake(30,
                                    size.height-115,
                                    size.width-60,
                                    TFScalePoint(35.0));
        
        [_doneBtn setBackgroundImage:[[UIImage imageNamed:@"meituan_btn"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]
                            forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
        if (!login && (_type == Flower || _type == Meituan || _type == MovieTicket))
        {
            [_doneBtn setTitle:@"登录"
                      forState:UIControlStateNormal];
        }
        else
        {
            [_doneBtn setTitle:@"同意"
                      forState:UIControlStateNormal];
        }
        [_doneBtn addTarget:self
                     action:@selector(done:)
           forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_doneBtn];
    }
    
    if (self.type == MeiWeiQiQi) {
        
        [self getFunctionModuleTipsDetail];
    }
    else
    {
    
        [self getProtocolDetail];
    }
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

#pragma mark private methods
- (void)done:(UIButton *)btn
{
    switch (self.type)
    {
        case Flower:
        {
            [self checkLogin:^{
                HYFlowerMainViewController *vc = [[HYFlowerMainViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case Meituan:
        {
            [self checkLogin:^{
                HYMeituanViewController *webBrowser = [[HYMeituanViewController alloc] init];
                webBrowser.showsURLInNavigationBar = NO;
                webBrowser.tintColor = [UIColor whiteColor];
                webBrowser.showsPageTitleInNavigationBar = NO;
                webBrowser.title = @"团购";
                
                [self.navigationController pushViewController:webBrowser animated:YES];
                
                HYUserInfo *user = [HYUserInfo getUserInfo];
                NSString *url = [NSString stringWithFormat:@"http://r.union.meituan.com/url/visit/?a=1&key=RuMI8Vh70pQsPn5mKiw1F4E9erHYbOdJ&sid=%@&url=http%%3A%%2F%%2Fi.meituan.com", user.userId];
                [webBrowser loadURL:[NSURL URLWithString:url]];
            }];
        }
            break;
        case MeiWeiQiQi:
        {
            HYMeituanViewController *meiWeiQiQiBrowser = [[HYMeituanViewController alloc] init];
            meiWeiQiQiBrowser.showsURLInNavigationBar = NO;
            meiWeiQiQiBrowser.tintColor = [UIColor whiteColor];
            meiWeiQiQiBrowser.showsPageTitleInNavigationBar = NO;
            meiWeiQiQiBrowser.title = @"美味七七";
            [self.navigationController pushViewController:meiWeiQiQiBrowser animated:YES];
            NSString *url = @"http://m.yummy77.com/home/index1?utm_source=mteshe&utm_medium=cpc&utm_term=%E7%89%B9%E5%A5%A2%E6%B1%87&utm_content=app&utm_campaign=%E7%89%B9%E5%A5%A2%E6%B1%87%E9%93%BE%E6%8E%A5";
            [meiWeiQiQiBrowser loadURL:[NSURL URLWithString:url]];
        }
            break;
        case MovieTicket:
        {
            [self checkLogin:^{
                _movieURLRequest = [[HYMovieGetURLRequest alloc] init];
                WS(weakSelf);
                [_movieURLRequest sendReuqest:^(id result, NSError *error)
                 {
                     if ([result isKindOfClass:[HYMovieGetURLResponse class]]) {
                         HYMovieGetURLResponse *resp = (HYMovieGetURLResponse *)result;
                         if (resp.status == 200)
                         {
                             HYMeituanViewController *webBrowser = [[HYMeituanViewController alloc] init];
                             webBrowser.showsURLInNavigationBar = NO;
                             webBrowser.tintColor = [UIColor whiteColor];
                             webBrowser.showsPageTitleInNavigationBar = NO;
                             webBrowser.title = @"电影票";
                             
                             NSString *url = [resp.URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                             [weakSelf.navigationController pushViewController:webBrowser animated:YES];
                             [webBrowser loadURL:[NSURL URLWithString:url]];
                         }
                         else
                         {
                             [METoast toastWithMessage:resp.suggestMsg];
                         }
                     }
                 }];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)upgradeImmediately
{
    HYUpgradeAlertView *alert = [[HYUpgradeAlertView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
    [alert showWithAnimation:YES];
    alert.controllerHandler = ^(HYUpdateToOfficialUserViewController *update, HYPaymentViewController *payment)
    {
        if (update)
        {
            [self.navigationController pushViewController:update animated:YES];
            [self removeSelfFromNav];
        }
        else if (payment)
        {
            payment.navbarTheme = self.navbarTheme;
            [self.navigationController pushViewController:payment animated:YES];
            [self removeSelfFromNav];
            payment.paymentCallback = ^(HYPaymentViewController *payvc, id data)
            {
                [payvc.navigationController popViewControllerAnimated:YES];
                
                HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
                vc.cashCard = @"1000";
                [self presentViewController:vc animated:YES completion:nil];
            };
        }
    };
}

-(void)removeSelfFromNav
{
    /*g
     *直接修改堆栈的层次
     */
    NSMutableArray *mTemp = [self.navigationController.viewControllers mutableCopy];
    [mTemp removeObject:self];
    self.navigationController.viewControllers = [mTemp copy];
}


- (void)getFunctionModuleTipsDetail
{
    if (!_getFunctionModuleTipsReq) {
        _getFunctionModuleTipsReq = [[HYGetFunctionModuleTipsRequest alloc] init];
    }
    
    _getFunctionModuleTipsReq.moduleCode = @"mwqq_tips";
    [_getFunctionModuleTipsReq sendReuqest:^(id result, NSError *error) {
        
        HYGetFunctionModuleTipsResponse *response = (HYGetFunctionModuleTipsResponse *)result;
        if (!error)
        {
            [_contentView loadHTMLString:response.mwqq_tips
                                 baseURL:nil];
        }
    }];
}

- (void)getProtocolDetail
{
    _getProtocolReq = [[HYGetProtocolReq alloc] init];
    switch (self.type)
    {
        case Flower:
        {
            _getProtocolReq.copywriting_key = @"flower_tips";
        }
            break;
        case Meituan:
        {
            _getProtocolReq.copywriting_key = @"meituan_tips";
        }
            break;
        case MovieTicket:
        {
            _getProtocolReq.copywriting_key = @"maizuo_tips";
            break;
        }
        default:
            break;
    }
    
    
    __weak typeof(self) bself = self;
    [_getProtocolReq sendReuqest:^(id result, NSError *error) {
        
        NSString *content = nil;
        if ([result isKindOfClass:[HYGetProtocolResp class]])
        {
            HYGetProtocolResp *resp = (HYGetProtocolResp *)result;
            content = resp.resTips;
//            switch (bself.type)
//            {
//                case Flower:
//                    content = resp.flower_tips;
//                    break;
//                case Meituan:
//                    content = resp.meituan_tips;
//                    break;
//                default:
//                    break;
//            }
        }
        
        [bself updateviewWithContent:content error:error];
    }];
}

- (void)updateviewWithContent:(NSString *)content error:(NSError *)error
{
    if (!error)
    {
        [_contentView loadHTMLString:content
                             baseURL:nil];
    }
}

@end
