//
//  HYRedpacketDetailViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRedpacketDetailViewController.h"
#import "UIImage+Addition.h"
#import "HYRedPacketNormalSendViewController.h"
#import "HYRedpacketsHomeViewController.h"
#import "UIView+ScreenTransform.h"
#import "HYSelectContactsViewController.h"
#import "UMSocialScreenShoter.h"
#import "UMSocial.h"
#import "UMSocialSnsService.h"
#import "HYGetRedpacketDetailReq.h"
#import "HYRedpacketRecv.h"
#import "HYUserInfo.h"

@interface HYRedpacketDetailViewController ()
<UMSocialUIDelegate>
{
    HYGetRedpacketDetailReq *_getDetailReq;
}

@property (nonatomic, strong) NSArray *recvList;

@property (nonatomic, assign) BOOL isShare;

@end

@implementation HYRedpacketDetailViewController

- (void)dealloc
{
    [_getDetailReq cancel];
    _getDetailReq = nil;
    
    [HYLoadHubView dismiss];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.isRecvPacket = NO;
        self.isShare = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"红包详情";
    if (self.view.frame.size.height <= 613)
    {
        self.contentView.contentSize = CGSizeMake(self.view.frame.size.width, TFScalePoint(613));
    }
    [self.returnBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_info_btn1"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]
                              forState:UIControlStateNormal];
    [self.returnBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_info_btn1_d"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]
                              forState:UIControlStateHighlighted];
    [self.shareBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_info_btn2"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]
                             forState:UIControlStateNormal];
    [self.shareBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_info_btn2_d"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]
                             forState:UIControlStateHighlighted];
    [self.sendBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_info_btn3"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]
                            forState:UIControlStateNormal];
    [self.sendBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_info_btn3_d"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]
                            forState:UIControlStateHighlighted];
    
    if (_isRecvPacket)  //从领红包界面进入时添加完成按钮
    {
        UIButton *listBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
        [listBtn setTitle:@"完成" forState:UIControlStateNormal];
        [listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        listBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [listBtn addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:listBtn];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    [self.contentView transformSubviewFrame:NO];
    
    [self updateView];
    
    if (!_recv)
    {
        [self loadRedpacketDetail];
    }
}

- (void)completeAction:(UIButton *)btn
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

#pragma mark private methods
- (void)updateView
{
    self.nameLab.text = self.redpacket.title;
    self.descLab.text = self.redpacket.greetings;
    self.pointLab.text = [NSString stringWithFormat:@"%d", self.recv.total_amount];
    self.timeLab.text = self.redpacket.created;
    
    CGSize size = [self.descLab.text sizeWithFont:self.descLab.font
                                constrainedToSize:self.descLab.frame.size];
    CGRect frame = self.descLab.frame;
    frame.size = size;
    self.descLab.frame = frame;
    
    //时间
    frame = self.timeLab.frame;
    frame.origin.y = self.descLab.frame.origin.y+size.height+14;
    self.timeLab.frame = frame;
    
    //红包
    frame = self.redpacketView.frame;
    frame.origin.y = CGRectGetMaxY(_timeLab.frame) + 10;
    self.redpacketView.frame = frame;
    
//    [self.redpacketView setImage:[UIImage imageWithNamedAutoLayout:@"t_info_img2"]];
    
    frame = self.pointLab.frame;
    frame.origin.y = self.redpacketView.center.y-frame.size.height/2;
    self.pointLab.frame = frame;
    
    frame = self.shareBtn.frame;
    frame.origin.y = self.redpacketView.frame.origin.y+self.redpacketView.frame.size.height+20;
    self.shareBtn.frame = frame;
    
    
    frame = self.sendBtn.frame;
    frame.origin.y = self.shareBtn.frame.origin.y+self.shareBtn.frame.size.height+12;
    self.sendBtn.frame = frame;
    
    self.contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(_sendBtn.frame) + 15);
}

- (void)loadRedpacketDetail
{
    if (self.redpacket.code)
    {
        [HYLoadHubView show];
        _getDetailReq = [[HYGetRedpacketDetailReq alloc] init];
        _getDetailReq.code = self.redpacket.code;
        
        __weak typeof(self) bself = self;
        [_getDetailReq sendReuqest:^(id result, NSError *error) {
            [bself updateGetRedDetailResult:(HYGetRedpacketDetailResp *)result
                                      error:error];
        }];
    }
}

- (void)updateGetRedDetailResult:(HYGetRedpacketDetailResp *)resp error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        self.redpacket = resp.redpacket;
        if (resp.recvList.count > 0)
        {
            HYUserInfo *userinfo = [HYUserInfo getUserInfo];
            NSString *phone = userinfo.mobilePhone;
            for (HYRedpacketRecv *recv in resp.recvList)
            {
                if ([recv.phone_mob isEqualToString:phone])
                {
                    self.recv = recv;
                }
            }
        }
        [self updateView];
    }
}

//回赠一个
- (IBAction)returnNewRedpacket:(id)sender
{
    if (self.redpacket.phone_mob)
    {
        HYRedPacketNormalSendViewController *vc = [[HYRedPacketNormalSendViewController alloc] initWithNibName:@"HYRedPacketNormalSendViewController" bundle:nil];
        vc.mob_phone = self.redpacket.phone_mob;
        vc.name = self.redpacket.send_user_name;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (IBAction)shareToFriends:(id)sender
{
    if (!_isShare)
    {
        _isShare = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImage *image = [[UMSocialScreenShoterDefault screenShoter] getScreenShot];
            
            //UMSocialWXMessageTypeImage 为纯图片类型
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;  //使用app类型的时候分享到会话无法跳转
            [UMSocialData defaultData].extConfig.title = @"";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = nil;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = nil;
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            [UMSocialData defaultData].extConfig.qzoneData.title = @"我发现了一款超赞的应用《特奢汇》";
            [UMSocialData defaultData].extConfig.qzoneData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";
            //[UMSocialData defaultData].extConfig.qzoneData.
            
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:uMengAppKey
                                              shareText:nil
                                             shareImage:image
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
                                               delegate:self];
        });
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

- (IBAction)sendRedpacket:(id)sender
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
    
//    HYSelectContactsViewController *vc = [[HYSelectContactsViewController alloc] init];
//    [self.navigationController pushViewController:vc
//                                         animated:YES];
}

@end
