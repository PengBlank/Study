//
//  HYShakeViewController.m
//  Teshehui
//
//  Created by HYZB on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYShakeViewController.h"
#import "UIImage+Addition.h"
#import "HYTabbarViewController.h"
#import "HYMallHomeViewController.h"
#import "HYNavigationController.h"
#import "HYShakeContentView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HYShakeViewRequest.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "HYShakeViewResponse.h"
#import "METoast.h"
#import "HYSignInViewController.h"
#import "HYShakeViewModel.h"
#import "HYProductDetailViewController.h"
#import "HYShakeProductPOModel.h"
#import "HYActivityProductListViewController.h"
#import "HYActivityGoodsRequest.h"
#import "HYActivityProductListViewController.h"
#import "HYPointsViewController.h"
#import "HYAccountBalanceViewController.h"
#import "HYShareGetPointViewController.h"
#import "HYShareInfoReq.h"
#import "UMSocialData.h"
#import "UMSocial.h"


@interface HYShakeViewController ()
<HYShakeContentViewDelegate,
UMSocialUIDelegate>
{
    HYShareInfoReq *_shareRequest;
    HYShakeViewRequest *_shakeReq;
}

@property (nonatomic, strong) HYShakeContentView *shakeView;
@property (nonatomic, strong) HYShakeViewModel *shakeModel;
@property (nonatomic, strong) HYShakeProductPOModel *productModel;

@end

@implementation HYShakeViewController

- (void)dealloc
{
    [_shakeReq cancel];
    _shakeReq = nil;
    
    [_shareRequest cancel];
    _shareRequest = nil;
    
    [HYLoadHubView dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"摇一摇";
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    
    UIImageView *backGroundImg = [[UIImageView alloc] initWithFrame:frame];
    [self.view addSubview:backGroundImg];
    backGroundImg.image = [UIImage imageNamed:@"pic_shake_newbackground"];
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(self.view.center.x-90,
                                                       self.view.center.y-TFScalePoint(160), 180, 180)];
    [self.view addSubview:imageView];
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=1; i<5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_shake_background_0%d",i]];
        [imgArray addObject:image];
    }
    imageView.animationImages = imgArray;
    imageView.animationDuration = 3*0.25;
    imageView.animationRepeatCount = 0;
    [imageView startAnimating];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
    [btn setTitle:@"签到" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithWhite:0.4f alpha:1.0f] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    HYShakeContentView *shakeView = [[HYShakeContentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shakeView.delegate = self;
    [shakeView.cancelBtn addTarget:self action:@selector(cancelBtnAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    _shakeView = shakeView;
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:shakeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self becomeFirstResponder];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

#pragma mark - HYShakeContentViewDelegate
/** 签到页面 */
- (void)goSignInView
{
    _shakeView.hidden = YES;
    HYSignInViewController *vc = [[HYSignInViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 现金劵页面 */
- (void)goTokenView
{
    _shakeView.hidden = YES;
    HYPointsViewController *vc = [[HYPointsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 账户余额页面 */
- (void)goBalanceView
{
    _shakeView.hidden = YES;
    HYAccountBalanceViewController *vc = [[HYAccountBalanceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 分享 */
- (void)goShowView
{
    _shakeView.hidden = YES;
    [self shareAction];
}

/** 商品详情页面 */
- (void)goDetailView
{
    _shakeView.hidden = YES;
    
    HYShakeProductPOModel *productModel = [[HYShakeProductPOModel alloc]
                                           initWithDictionary:_shakeModel.productPO error:nil];
    HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
    vc.goodsId = productModel.productCode;
    [self.navigationController pushViewController:vc animated:NO];
}

/** 活动页面 */
- (void)goActivityView
{
    _shakeView.hidden = YES;
    
    HYActivityGoodsRequest *req = [[HYActivityGoodsRequest alloc] init];
    req.activityCode = _shakeModel.currentCode;
    
    HYActivityProductListViewController *list = [[HYActivityProductListViewController alloc] init];
    list.getDataReq = req;
    list.title = _shakeModel.shakeName;
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark - privateMethod
- (void)shareAction
{

    if (!_shareRequest)
    {
        _shareRequest = [[HYShareInfoReq alloc] init];
    }
    _shareRequest.type = @"7";
    [HYLoadHubView show];
    
    [_shareRequest sendReuqest:^(HYShareInfoResp* res, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (res.status == 200)
         {
             NSData *imgdata;
             if (res.imgurl.length > 0)
             {
                 imgdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:res.imgurl]];
             }
             else
             {
                 UIImage *shareImg = [UIImage imageNamed:@"share_icon"];
                 imgdata = UIImageJPEGRepresentation(shareImg, 1);
             }

             
             //使用app类型的时候分享到会话无法跳转
             [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
             
             [UMSocialData defaultData].extConfig.title = res.title;
             [UMSocialData defaultData].extConfig.wechatSessionData.url = res.url;
             [UMSocialData defaultData].extConfig.wechatTimelineData.url = res.url;

             [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
             [UMSocialData defaultData].extConfig.qqData.url = res.url;
             [UMSocialData defaultData].extConfig.qzoneData.title = res.title;
             [UMSocialData defaultData].extConfig.qzoneData.url = res.url;
             [UMSocialData defaultData].extConfig.qqData.title = res.title;

             [UMSocialSnsService presentSnsIconSheetView:self
                                                  appKey:uMengAppKey
                                               shareText:[NSString stringWithFormat:@"%@%@", res.msg, res.url]
                                              shareImage:imgdata
                                         shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,
                                                          UMShareToWechatSession,UMShareToWechatTimeline,
                                                          UMShareToSina,nil]
                                                delegate:self];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:res.rspDesc delegate:nil
                                                   cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (void)cancelBtnAction:(UIButton *)btn
{
    _shakeView.hidden = YES;
    [self becomeFirstResponder];
}

- (void)rightBtnAction:(UIButton *)btn
{
    HYSignInViewController *vc = [[HYSignInViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        SystemSoundID soundID;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_sound"ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &soundID);
        //播放声音
        AudioServicesPlaySystemSound (soundID);
        //播放震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [self loadData];
    }
}

- (void)loadData 
{
    if (!_shakeReq)
    {
        _shakeReq = [[HYShakeViewRequest alloc] init];
    }
    
    NSString *useId = [HYUserInfo getUserInfo].userId;
    if (useId)
    {
        _shakeReq.userId = useId;
    }
    
    WS(weakSelf)
    [HYLoadHubView show];
    [_shakeReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        HYShakeViewResponse *respon = (HYShakeViewResponse *)result;
        if (respon.status == 200)
        {
            if (respon.shakeModel.shakeType.integerValue > 0)
            {
                weakSelf.shakeView.hidden = NO;
                weakSelf.shakeModel = respon.shakeModel;
                weakSelf.shakeView.shakeModel = respon.shakeModel;
                [weakSelf resignFirstResponder];
            }
        }
        else
        {
            [METoast toastWithMessage:respon.suggestMsg];
        }
    }];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark UMeng
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    [self becomeFirstResponder];
}

@end
