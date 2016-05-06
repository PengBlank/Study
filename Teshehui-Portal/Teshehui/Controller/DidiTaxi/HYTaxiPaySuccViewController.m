//
//  HYTaxiPaySuccViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiPaySuccViewController.h"
#import "HYTabbarViewController.h"
#import "HYTaxiOrderListViewController.h"
#import "HYImageButton.h"
#import "UMSocial.h"
#import "HYShareInfoReq.h"

@interface HYTaxiPaySuccViewController ()
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, strong) HYShareInfoReq *shareRequest;
@end

@implementation HYTaxiPaySuccViewController

- (void)dealloc
{
    [_shareRequest cancel];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
    self.view = view;
    
    UIImage *icon = [UIImage imageNamed:@"taxi_success"];
    UIImageView *iconv= [[UIImageView alloc] initWithImage:icon];
    iconv.frame = CGRectMake(frame.size.width/2 - icon.size.width/2,
                             70,
                             icon.size.width,
                             icon.size.height);
    [self.view addSubview:iconv];
    
    UILabel * _infoLab = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                   CGRectGetMaxY(iconv.frame)+20,
                                                                   frame.size.width-40,
                                                                   30)];
    _infoLab.backgroundColor = [UIColor clearColor];
    _infoLab.font = [UIFont systemFontOfSize:24];
    _infoLab.textColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:84/255.0 alpha:1];
    _infoLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_infoLab];
    _infoLab.text = @"支付成功!";
    
    UILabel * _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_infoLab.frame)+10, frame.size.width-40, 30)];
    _detailLab.backgroundColor = [UIColor clearColor];
    _detailLab.font = [UIFont systemFontOfSize:15.0];
    _detailLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
    _detailLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_detailLab];
    _detailLab.text = @"现金券将发至您的账户中, 请笑纳~";
    
    
    CGFloat footx = frame.size.height - 200;
    UILabel *footLab = [[UILabel alloc] initWithFrame:CGRectMake(0, footx, frame.size.width, 15)];
    footLab.font = [UIFont systemFontOfSize:15.0];
    footLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
    footLab.text = @"推荐好友也来用";
    [footLab sizeToFit];
    footLab.frame = CGRectMake(frame.size.width/2 - footLab.frame.size.width/2,
                               footx,
                               footLab.frame.size.width,
                               footLab.frame.size.height);
    [self.view addSubview:footLab];
    
    CGFloat linewidth = 50;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(footLab.frame) - linewidth-10,
                                                             CGRectGetMidY(footLab.frame),
                                                             linewidth,
                                                             1)];
    line1.backgroundColor = [UIColor colorWithWhite:.7 alpha:1];
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(footLab.frame) + 10,
                                                             CGRectGetMidY(footLab.frame),
                                                             linewidth,
                                                             1)];
    line2.backgroundColor = [UIColor colorWithWhite:.7 alpha:1];
    [self.view addSubview:line2];
    
    CGFloat buttonx = 20;
    CGFloat buttonwidth = (frame.size.width - buttonx * 2) / 4;
    HYImageButton *button1 = [[HYImageButton alloc] initWithFrame:CGRectMake(buttonx, CGRectGetMaxY(footLab.frame) + 20, buttonwidth, 50)];
    [button1 setImage:[UIImage imageNamed:@"icon_qq_login"] forState:UIControlStateNormal];
    [button1 setTitle:@"QQ" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 1;
    button1.spaceInTestAndImage = 5;
    [button1 setTitleColor:[UIColor colorWithWhite:.7 alpha:1] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:button1];
    buttonx += buttonwidth;
    
    HYImageButton *button2 = [[HYImageButton alloc] initWithFrame:CGRectMake(buttonx, CGRectGetMaxY(footLab.frame) + 20, buttonwidth, 50)];
    [button2 setImage:[UIImage imageNamed:@"icon_weixin_login"] forState:UIControlStateNormal];
    [button2 setTitle:@"微信" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 2;
    [button2 setTitleColor:[UIColor colorWithWhite:.7 alpha:1] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button2.spaceInTestAndImage = 5;
    [self.view addSubview:button2];
    buttonx += buttonwidth;
    
    HYImageButton *button3 = [[HYImageButton alloc] initWithFrame:CGRectMake(buttonx, CGRectGetMaxY(footLab.frame) + 20, buttonwidth, 50)];
    [button3 setImage:[UIImage imageNamed:@"icon_login_quan"] forState:UIControlStateNormal];
    [button3 setTitle:@"朋友圈" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    button3.tag = 3;
    [button3 setTitleColor:[UIColor colorWithWhite:.7 alpha:1] forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button3.spaceInTestAndImage = 5;
    [self.view addSubview:button3];
    buttonx += buttonwidth;
    
    HYImageButton *button4 = [[HYImageButton alloc] initWithFrame:CGRectMake(buttonx, CGRectGetMaxY(footLab.frame) + 20, buttonwidth, 50)];
    [button4 setImage:[UIImage imageNamed:@"icon_login_weibo"] forState:UIControlStateNormal];
    [button4 setTitle:@"微博" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    button4.tag = 4;
    [button4 setTitleColor:[UIColor colorWithWhite:.7 alpha:1] forState:UIControlStateNormal];
    button4.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button4.spaceInTestAndImage = 5;
    [self.view addSubview:button4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"支付成功";
    self.canDragBack = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareAction:(UIButton *)btn
{
    if (!_isShare)
    {
        if (!_shareRequest)
        {
            _shareRequest = [[HYShareInfoReq alloc] init];
        }
        _shareRequest.type = @"6";
        [HYLoadHubView show];
        _isShare = YES;
        __weak typeof(self) b_self = self;
        [_shareRequest sendReuqest:^(HYShareInfoResp* res, NSError *error)
         {
             [HYLoadHubView dismiss];
             b_self.isShare = NO;
             if (res.status == 200)
             {
                 NSData *imgData = nil;
                 if (res.imgurl)
                 {
                     imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:res.imgurl]];
                 }
                 else
                 {
                     imgData = UIImageJPEGRepresentation([UIImage imageNamed:@"share_icon"], 1);
                 }
                 
                 NSString *title = res.title;
                 NSString *content = res.msg;
                 UMSocialUrlResource *url = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:res.url];
                 
                 [UMSocialControllerService defaultControllerService].socialData.shareText = content;
                 [UMSocialControllerService defaultControllerService].socialData.shareImage = imgData;
                 [UMSocialControllerService defaultControllerService].socialData.urlResource = url;
                 
                 [UMSocialControllerService defaultControllerService].socialData.extConfig.qqData.title = title;
                 [UMSocialControllerService defaultControllerService].socialData.extConfig.qqData.url = res.url;
                 
                 [UMSocialControllerService defaultControllerService].socialData.extConfig.wechatTimelineData.title = title;
                 [UMSocialControllerService defaultControllerService].socialData.extConfig.wechatTimelineData.url = res.url;
                 
                 [UMSocialControllerService defaultControllerService].socialData.extConfig.wechatSessionData.title = title;
                 [UMSocialControllerService defaultControllerService].socialData.extConfig.wechatSessionData.url = res.url;
                 [UMSocialControllerService defaultControllerService].socialData.title = title;
                 
                 if (btn.tag == 4)
                 {
                     [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(b_self,[UMSocialControllerService defaultControllerService],YES);
                 }
                 else if (btn.tag == 3)
                 {
                     [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(b_self,[UMSocialControllerService defaultControllerService],YES)
                    ;
                 }
                 else if (btn.tag == 2)
                 {
                     [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(b_self,[UMSocialControllerService defaultControllerService],YES);
                 }
                 else if (btn.tag == 1)
                 {
                     [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(b_self,[UMSocialControllerService defaultControllerService],YES);
                 }
             }
             else
             {
                 b_self.isShare = NO;
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:res.rspDesc
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
}

//- (void)backToRootViewController:(id)sender
//{
//    //强行将自己塞到订单列表的下一个界面
//    HYTabbarViewController *tab = (HYTabbarViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    UINavigationController *nav = [tab.viewControllers objectAtIndex:3];
//    NSMutableArray *vcs = [nav.viewControllers mutableCopy];
//    [vcs removeObjectsInRange:NSMakeRange(1, vcs.count-1)];
//    nav.viewControllers = vcs;
//    
//    HYTaxiOrderListViewController *list = [[HYTaxiOrderListViewController alloc] init];
//    [nav pushViewController:list animated:NO];
//    [nav pushViewController:self animated:NO];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    [tab setCurrentSelectIndex:3];
//    [tab setTabbarShow:NO];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
