//
//  HYPointsViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYPointsViewController.h"
#import "HYCoinAccoutViewController.h"
#import "HYRedpacketsHomeViewController.h"
#import "HYShareGetPointViewController.h"
#import "HYGetUserInfoRequest.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "HYGetPersonResponse.h"
#import "METoast.h"

@interface HYPointsViewController ()

@property (nonatomic, strong) UILabel *pointLab;
@property (nonatomic, strong) HYGetUserInfoRequest *infoReq;

@end

@implementation HYPointsViewController
- (void)dealloc
{
    [_infoReq cancel];
    _infoReq = nil;
    
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    
    UIImage *icon = [UIImage imageNamed:@"icon_quan"];
    UIImageView *iconv = [[UIImageView alloc] initWithImage:icon];
    iconv.frame = CGRectMake(CGRectGetMidX(frame)-icon.size.width/2, TFScalePoint(60), icon.size.width, icon.size.height);
    [self.view addSubview:iconv];
    
    /// 我的现金券
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(iconv.frame), CGRectGetMaxY(iconv.frame)+20, CGRectGetWidth(iconv.frame), 20)];
    label1.text = @"我的现金券";
    label1.textColor = [UIColor colorWithWhite:.5 alpha:1];
    label1.font = [UIFont systemFontOfSize:14.0];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    /// 数目
    UILabel *pointLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame) + 10, frame.size.width, 30)];
    pointLab.font = [UIFont systemFontOfSize:32];
    pointLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:pointLab];
    self.pointLab = pointLab;
    
    /// 分享赚
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(pointLab.frame) + TFScalePoint(40), frame.size.width-40, 44)];
    shareBtn.backgroundColor = [UIColor colorWithRed:249/255.0 green:202/255.0 blue:1/255.0 alpha:1];
    [shareBtn setTitle:@"分享赚现金券" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.layer.cornerRadius = 4.0;
    shareBtn.layer.masksToBounds = YES;
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    
    /// 发红包
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(shareBtn.frame) + 10, frame.size.width-40, 44)];
    sendBtn.backgroundColor = [UIColor colorWithRed:221/255.0 green:39/255.0 blue:38/255.0 alpha:1];
    [sendBtn setTitle:@"发红包" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 4.0;
    sendBtn.layer.masksToBounds = YES;
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"现金券余额";
    
    UIButton *listBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    [listBtn setTitle:@"查看账单" forState:UIControlStateNormal];
    [listBtn setTitleColor:[UIColor colorWithWhite:.5 alpha:1] forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
    listBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    UIBarButtonItem *list = [[UIBarButtonItem alloc] initWithCustomView:listBtn];
    self.navigationItem.rightBarButtonItem = list;
    
//    self.pointLab.text = [NSString stringWithFormat:@"%ld", self.points];
    [self loadDate];
}

- (void)loadDate
{
    if (!_infoReq)
    {
        _infoReq = [[HYGetUserInfoRequest alloc] init];
    }
    NSString *userId = [HYUserInfo getUserInfo].userId;
    if (userId)
    {
        _infoReq.userId = userId;
    }
    [HYLoadHubView show];
    WS(weakSelf)
    [_infoReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        HYGetPersonResponse *response = (HYGetPersonResponse *)result;
        if (response.status == 200)
        {
           weakSelf.pointLab.text = response.userInfo.points;
        }
        else
        {
            [METoast toastWithMessage:response.suggestMsg];
        }
    }];
}

- (void)listAction:(UIBarButtonItem *)item
{
    [MobClick event:kCashTicketViewAccountClick];
    
    HYCoinAccoutViewController *vc = [[HYCoinAccoutViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareAction:(UIButton *)btn
{
    [MobClick event:kCashTicketShareToEarnClick];
    
    HYShareGetPointViewController *vc = [[HYShareGetPointViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendAction:(UIButton *)btn
{
    [MobClick event:kCashTicketSendRedPacketClick];
    
    HYRedpacketsHomeViewController *vc = [[HYRedpacketsHomeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
