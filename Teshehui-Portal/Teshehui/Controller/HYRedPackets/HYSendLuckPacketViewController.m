//
//  HYSendLuckPacketViewController.m
//  Teshehui
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSendLuckPacketViewController.h"
#import "UIImage+Addition.h"
#import "HYRPCodeGenerateViewController.h"
#import "UIView+ScreenTransform.h"
#import "HYRedpacketsHomeViewController.h"
#import "HYShareRedpacketReq.h"

#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "UMSocial.h"

@interface HYSendLuckPacketViewController ()
<UMSocialUIDelegate>
{
    HYShareRedpacketReq *_shareReq;
}

@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *sendBtn;

@end

@implementation HYSendLuckPacketViewController

- (void)dealloc
{
    [_shareReq cancel];
    _shareReq = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"给朋友发红包";
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    if (frame.size.height <= 480)
    {
        _scrollView.contentSize = CGSizeMake(320, 504);
    }
    
    UIImage *btn = [[UIImage imageNamed:@"redpacket_send_btn.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 24, 0, 24)];
    [self.sendBtn setBackgroundImage:btn forState:UIControlStateNormal];
    
    [self.scrollView transformSubviewFrame:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 从后台进入，如果已点击发送，则退回
- (void)didEnterActive:(NSNotification *)n
{
    if (_isShare) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - actions
- (IBAction)generateCode:(id)sender
{
    //特令红包
    /*
    HYRPCodeGenerateViewController *vc = [[HYRPCodeGenerateViewController alloc] initWithNibName:@"HYRPCodeGenerateViewController" bundle:nil];
    vc.packetInfo = self.sendedPacketInfo;
    [self.navigationController pushViewController:vc animated:YES];
     */

    if (!_isShare)
    {
        
        HYShareRedpacketResp *resp = self.sendedPacketInfo;
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:resp.title_url]];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
        [UMSocialData defaultData].extConfig.title = resp.title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = resp.red_packet_url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = resp.red_packet_url;
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:uMengAppKey
                                          shareText:resp.greetings
                                         shareImage:imgData
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                           delegate:self];
    }
}

#pragma mark UM Delegate
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    _isShare = YES;
    
    if ([self.type isEqualToString:@"普通红包"])
    {
        if (kPutIntoRedPacketToShareWithWeChatFriendClick == platformName)
        {
            [MobClick event:kNormalRedPacketPutIntoAndShareWithFriendClick];
        }
        else if (kPutIntoRedPacketToShareWithWeChatFriendCircleClick == platformName)
        {
            [MobClick event:kNormalRedPacketPutIntoAndShareWithFriendCircleClick];
        }
    }
    else if ([self.type isEqualToString:@"拼手气红包"])
    {
        if (kPutIntoRedPacketToShareWithWeChatFriendClick == platformName)
        {
            [MobClick event:kPutIntoRedPacketToShareWithWeChatFriendClick];
        }
        else if (kPutIntoRedPacketToShareWithWeChatFriendCircleClick == platformName)
        {
            [MobClick event:kPutIntoRedPacketToShareWithWeChatFriendCircleClick];
        }
    }
    
   
}

#pragma mark private methods
- (void)backToRootViewController:(id)sender
{
    UIViewController *root = nil;
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[HYRedpacketsHomeViewController class]])
        {
            root = vc;
        }
    }
    [self.navigationController popToViewController:root animated:YES];
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
