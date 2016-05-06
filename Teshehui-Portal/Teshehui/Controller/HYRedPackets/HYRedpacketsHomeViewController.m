//
//  HYRedpacketsHomeViewController.m
//  Teshehui
//
//  Created by apple on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRedpacketsHomeViewController.h"
#import "UIImage+Addition.h"
#import "HYLuckPacketCreateViewController.h"
#import "HYRPPasswordRecvViewController.h"
#import "HYSelectContactsViewController.h"
#import "HYRedpacketRecordViewController.h"
#import "HYRedPacketNormalSendViewController.h"


@interface HYRedpacketsHomeViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIButton *luckPacketBtn;
@property (nonatomic, weak) IBOutlet UIButton *normalPacketBtn;
@property (nonatomic, weak) IBOutlet UIButton *tokenPacketBtn;

@end

@implementation HYRedpacketsHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"现金券红包";
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    _scrollView.frame = frame;
    if (frame.size.height <= 416)
    {
        _contentView.frame = CGRectMake(0, 0, frame.size.width, TFScalePoint(504));
    }
    else
    {
        _contentView.frame = frame;
    }
    _scrollView.contentSize = _contentView.frame.size;
    
    UIImage *btn = [[UIImage imageNamed:@"redpacket_index_btn.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
    UIImage *btn_d = [[UIImage imageNamed:@"redpacket_index_btn_d.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
    [self.luckPacketBtn setBackgroundImage:btn forState:UIControlStateNormal];
    [self.luckPacketBtn setBackgroundImage:btn_d forState:UIControlStateHighlighted];
    [self.normalPacketBtn setBackgroundImage:btn forState:UIControlStateNormal];
    [self.normalPacketBtn setBackgroundImage:btn_d forState:UIControlStateHighlighted];
    [self.tokenPacketBtn setBackgroundImage:btn forState:UIControlStateNormal];
    [self.tokenPacketBtn setBackgroundImage:btn_d forState:UIControlStateHighlighted];
    
    /// 4.4.0去掉特币领红包功能
    self.tokenPacketBtn.hidden = YES;
    
    UIButton *listBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [listBtn setTitle:@"我的红包" forState:UIControlStateNormal];
    [listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    listBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [listBtn addTarget:self action:@selector(packetListAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:listBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:kIsShowRedpacket];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
/**
 *  @brief  拼手气红包
 *
 *  @param sender
 */
- (IBAction)luckBtnAction:(id)sender
{
    [MobClick event:kRedPacketPKLuckClick];
    
    HYLuckPacketCreateViewController *vc = [[HYLuckPacketCreateViewController alloc] initWithNibName:@"HYLuckPacketCreateViewController" bundle:nil];
    vc.randomLucky = YES;
    vc.title = @"拼手气红包";
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @brief  普通红包
 *
 *  @param sender
 */
- (IBAction)normalPacketAction:(id)sender
{
    
}

/**
 *  @brief  特令红包
 *
 *  @param sender
 */
- (IBAction)orderPacketAction:(id)sender
{
    HYRPPasswordRecvViewController *vc = [[HYRPPasswordRecvViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


/**
 *  @brief 发送普通红包
 *
 *  @param sender 
 *  @comment    4.4.0版本不再选择联系人，与特令红包一致，通过微信发送
 */
- (IBAction)sendNormalRedpacket:(id)sender
{
    /*
    HYSelectContactsViewController *vc = [[HYSelectContactsViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
     */
//    HYRedPacketNormalSendViewController *vc = [[HYRedPacketNormalSendViewController alloc] initWithNibName:@"HYRedPacketNormalSendViewController" bundle:nil];
//    [self.navigationController pushViewController:vc
//                                           animated:YES];
    [MobClick event:kRedPacketNormalRedPacketClick];
    
    HYLuckPacketCreateViewController *vc = [[HYLuckPacketCreateViewController alloc] initWithNibName:@"HYLuckPacketCreateViewController" bundle:nil];
    vc.randomLucky = NO;
    vc.title = @"普通红包";
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @brief  红包记录
 *
 *  @param sender
 */
- (void)packetListAction:(id)sender
{
    [MobClick event:kRedPacketMyRedPacketClick];
    
    HYRedpacketRecordViewController *vc = [[HYRedpacketRecordViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
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
