//
//  SceneConsumDetailTabButtonsController.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

/**
 *  这个页面分享和拨打电话都是复制的“中心”代码
 *   可以考虑建一个公共类调用
 */

#import "SceneConsumDetailTabButtonsController.h"
#import "SceneBookDetailViewController.h"
#import "HYUserInfo.h"
#import "HYAppDelegate.h"
#import "UMSocial.h"
#import "NSString+Common.h"
#import "DefineConfig.h"
#import "METoast.h"
#import "TYAnalyticsManager.h"
#define CSS_ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SceneConsumDetailTabButtonsController ()<UMSocialUIDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnLick;     // 点赞
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UIButton *bntShare;
@property (weak, nonatomic) IBOutlet UIButton *btnBookNow;  // 立即预订

@end

@implementation SceneConsumDetailTabButtonsController

- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
    self.isShare = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self setLickButtonEdgeInsets];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击事件
//点赞
- (IBAction)btnLickClick:(UIButton *)sender {
    
    if (!_btnLick.selected && (_detailInfo.status != 2)) {
        [self showEnlargeLickImage];
        [self.buttonDelegate SceneConsumDetailTabButtonsControllerLikeButtonClick];
    }else{
        [METoast toastWithMessage:@"亲，您刚刚已点过赞了哦"];
    }
}

//电话
- (IBAction)btnCallClick:(id)sender {
    //统计
    [[TYAnalyticsManager sharedManager] sendAnalyseForSceneBtnClick:DetailpagePhoneBtn];
    
    [self telBtnCallback];
}
//分享
- (IBAction)btnShareClick:(id)sender {
    //统计
    [[TYAnalyticsManager sharedManager] sendAnalyseForSceneBtnClick:DetailpageShareBtn];
    
    [self shareProduct:nil];
}
// 立即预订
- (IBAction)btnBookNowClick:(id)sender {
    
    //统计
    [[TYAnalyticsManager sharedManager] sendAnalyseForSceneBtnClick:DestineBtn];
    
    NSString *userid = [HYUserInfo getUserInfo].userId;
    if (userid.length == 0)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
    else
    {
        SceneBookDetailViewController *bookController = [[SceneBookDetailViewController alloc]init];
        bookController.detailInfo = _detailInfo;
        bookController.cityName = _cityName;
        [self.parentViewController.navigationController pushViewController:bookController animated:YES];
    }
}

#pragma mark - 内部方法
// 设置setter
- (void) setDetailInfo:(SceneDeatilInfo *)detailInfo {
    _detailInfo = detailInfo;
    if (detailInfo.favorites.length > 0) {
        [self.btnLick setHighlighted:YES];
        [self.btnLick setTitle:detailInfo.favorites forState:UIControlStateNormal];
        [self setLickButtonEdgeInsets];
    }
    if (detailInfo.status == 2) {
        self.btnBookNow.enabled = NO;
        self.btnLick.enabled = NO;
        self.btnPhone.enabled = NO;
        self.bntShare.enabled = NO;
        self.btnBookNow.backgroundColor = CSS_ColorFromRGB(0x707070);
    }
}
- (void) setFavoriteCount:(NSString *)FavoriteCount {
    [self.btnLick setTitle:FavoriteCount forState:UIControlStateNormal];
    [self setLickButtonEdgeInsets];
}

// button　图片和文字上下布局
- (void) setLickButtonEdgeInsets {
    CGFloat offset = 5.0f;
    self.btnLick.titleEdgeInsets = UIEdgeInsetsMake(0, -_btnLick.imageView.frame.size.width, -_btnLick.imageView.frame.size.height-offset/2, 0);
    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
    self.btnLick.imageEdgeInsets = UIEdgeInsetsMake(-_btnLick.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -_btnLick.titleLabel.intrinsicContentSize.width);
}

// 显示放大效果的点赞
- (void) showEnlargeLickImage {
    WS(weakSelf);
    
    self.view.backgroundColor = [UIColor whiteColor];
    _btnLick.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.0 animations:^{
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];;
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [ weakSelf.btnLick.layer addAnimation:k forKey:@"SHOW"];
    } completion:^(BOOL finished) {
          weakSelf.btnLick.selected = YES;
    }];
}


- (void)shareProduct:(id)sender
{
    self.isShare = YES;

    NSString *userid = [HYUserInfo getUserInfo].userId;
    if (userid.length == 0)
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
    else
    {
        UIImage *img = nil;
        if (_shareImage)
            img = _shareImage;
        else
            img = [UIImage imageNamed:@"share_icon"];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
        NSString *shareUrl = [NSString stringToUTF8:_detailInfo.urlShare];
        [UMSocialData defaultData].extConfig.title                  = _detailInfo.packageName;
        [UMSocialData defaultData].extConfig.wechatSessionData.url  = shareUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
//        [UMSocialData defaultData].extConfig.qqData.qqMessageType   = UMSocialQQMessageTypeDefault;
        [UMSocialData defaultData].extConfig.qqData.url             = shareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title        = _detailInfo.packageName;
        [UMSocialData defaultData].extConfig.qzoneData.url          = shareUrl;
        [UMSocialData defaultData].extConfig.qqData.title           = _detailInfo.packageName;
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:uMengAppKey
                                          shareText:[NSString stringWithFormat:@"我在特奢汇上体验了一场别具一格的美食&娱乐的盛宴 一起来吧！%@",shareUrl]
                                         shareImage:img
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
                                           delegate:self];
    }
}


- (void)telBtnCallback
{
    
    if (_detailInfo.merchantMobile.length == 0) {
        [METoast toastWithMessage:@"暂时无法联系商家"];
        return;
    }

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:_detailInfo.merchantMobile otherButtonTitles:nil, nil];
    [sheet showInView:KEY_WINDOW];
}


#pragma mark -- actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        NSString *s = [actionSheet buttonTitleAtIndex:buttonIndex];;
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",s];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}


-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    self.isShare = NO;
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

- (void)dealloc{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
