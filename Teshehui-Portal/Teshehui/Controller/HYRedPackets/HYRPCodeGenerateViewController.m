//
//  HYRPCodeGenerateViewController.m
//  Teshehui
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPCodeGenerateViewController.h"
#import "UIImage+Addition.h"
#import "UIView+ScreenTransform.h"
#import "UIView+GetImage.h"
#import "UMSocial.h"
#import "UMSocialSnsService.h"

@interface HYRPCodeGenerateViewController ()
<UMSocialUIDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *totalLab;
@property (nonatomic, weak) IBOutlet UIImageView *frameView;
@property (nonatomic, weak) IBOutlet UIButton *shareBtn;
@property (nonatomic, weak) IBOutlet UILabel *codeLab;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, assign) BOOL isShare;

@end

@implementation HYRPCodeGenerateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"群红包";
    
    CGRect tframe = [[UIScreen mainScreen] bounds];
    if (tframe.size.height <= 480)
    {
        _scrollView.contentSize = CGSizeMake(320, 490);
    }
//    _scrollView.contentSize = CGSizeMake(TFScalePoint(320), TFScalePoint(568));
    
    UIImage *frame = [[UIImage imageNamed:@"t_teling_input.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 35, 0, 35)];
    self.frameView.image = frame;
    
    UIImage *btn = [[UIImage imageNamed:@"redpacket_index_btn.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIImage *btn_d = [[UIImage imageNamed:@"redpacket_index_btn_d.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.shareBtn setBackgroundImage:btn forState:UIControlStateNormal];
    [self.shareBtn setBackgroundImage:btn_d forState:UIControlStateHighlighted];
    
    [self.scrollView transformSubviewFrame:NO];
    
    //总额
    self.totalLab.text = [NSString stringWithFormat:@"群红包现金券总额:%d现金券", self.packetInfo.total_amount];
    
    //特令
    self.codeLab.text = self.packetInfo.luck_password;
    
    self.isShare = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (IBAction)shareAction:(id)sender
{
    if (!_isShare)
    {
        UIImage *image = [self.contentView getImage];
        
        //UMSocialWXMessageTypeImage 为纯图片类型
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;  //使用app类型的时候分享到会话无法跳转
        [UMSocialData defaultData].extConfig.title = @"";
        [UMSocialData defaultData].extConfig.wechatSessionData.url = nil;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = nil;
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
        [UMSocialData defaultData].extConfig.qzoneData.title = @"我发现了一款超赞的应用《特奢汇》";
        [UMSocialData defaultData].extConfig.qzoneData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";
        //[UMSocialData defaultData].extConfig.qzoneData.
        
        [UMSocialData defaultData].extConfig.sinaData.urlResource = nil;
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:uMengAppKey
                                          shareText:nil
                                         shareImage:image
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
                                           delegate:self];
    }
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    _isShare = NO;
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    _isShare = NO;
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
