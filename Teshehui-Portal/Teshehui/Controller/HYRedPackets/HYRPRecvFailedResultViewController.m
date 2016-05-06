//
//  HYRPRecvFailedResultViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPRecvFailedResultViewController.h"
#import "UIImage+Addition.h"
#import "UIView+ScreenTransform.h"
#import "HYRPOtherListViewController.h"
#import "HYRedpacketDetailViewController.h"

@interface HYRPRecvFailedResultViewController ()

@end

@implementation HYRPRecvFailedResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"红包详情";
    [self.contentView transformSubviewFrame:NO];
    [self updateView];
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
    if (self.view.frame.size.height <= 504)
    {
        self.contentView.contentSize = CGSizeMake(self.view.frame.size.width, TFScalePoint(504));
    }
    
    self.nameLab.text = self.redpacket.title;
    self.descLab.text = self.redpacket.greetings;
    self.timeLab.text = self.redpacket.created;
    
    CGSize size = [self.descLab.text sizeWithFont:self.descLab.font
                                constrainedToSize:self.descLab.frame.size];
    CGRect frame = self.descLab.frame;
    frame.size = size;
    self.descLab.frame = frame;
    
    frame = self.timeLab.frame;
    frame.origin.y = CGRectGetMaxY(_descLab.frame) + 10;
    self.timeLab.frame = frame;
    
    frame = self.redpacketView.frame;
    frame.origin.y = CGRectGetMaxY(_timeLab.frame) + 10;
    self.redpacketView.frame = frame;
    
//    [self.redpacketView setImage:[UIImage imageWithNamedAutoLayout:@"t_hongbao_overdate"]];
//    self.errMsgLab.text = @"来晚了,红包已过期...";
    
    switch (self.redpacket.recv_status)
    {
        case RPRecvExpired:
            [self.redpacketView setImage:[UIImage imageNamed:@"t_hongbao_overdate"]];
            self.errMsgLab.text = @"来晚了,红包已过期...";
            break;
        case RPRecvEmpty:
            [self.redpacketView setImage:[UIImage imageNamed:@"t_hongbao_over2"]];
            self.errMsgLab.text = @"来晚了,红包已被抢完...";
            break;
        case RPRecvReceived:
            [self.redpacketView setImage:[UIImage imageNamed:@"t_hongbao_over"]];
            self.errMsgLab.text = @"你已经领过一次啦,把机会留给其他小伙伴吧!";
            break;
        default:
            break;
    }
    
    if (self.redpacket.recv_status == RPRecvReceived)   //到红包详情
    {
        [self.checkBtn setHidden:NO];
        frame = self.checkBtn.frame;
        frame.origin.y = CGRectGetMaxY(_errMsgLab.frame) + 10;
        self.checkBtn.frame = frame;
        [self.checkBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_info_btn1"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]
                                 forState:UIControlStateNormal];
        [self.checkBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_info_btn1_d"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]
                                 forState:UIControlStateHighlighted];
        [self.checkBtn setTitle:@"查看红包详情" forState:UIControlStateNormal];
        [self.checkBtn addTarget:self action:@selector(checkDetail:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (self.redpacket.recv_status == RPRecvEmpty) //列表
    {
        [self.checkBtn setHidden:NO];
        frame = self.checkBtn.frame;
        frame.origin.y = CGRectGetMaxY(_errMsgLab.frame) + 10;
        self.checkBtn.frame = frame;
        [self.checkBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_info_btn1"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]
                                 forState:UIControlStateNormal];
        [self.checkBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_info_btn1_d"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]
                                 forState:UIControlStateHighlighted];
        [self.checkBtn setTitle:@"查看领取详情" forState:UIControlStateNormal];
        [self.checkBtn addTarget:self action:@selector(checkList:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self.checkBtn setHidden:YES];
    }
    
    
}

//到红包详情
- (IBAction)checkDetail:(id)sender
{
    HYRPOtherListViewController *vc = [[HYRPOtherListViewController alloc] init];
    //vc.redpacket = rp;
    vc.redpacketCode = _redpacket.code;
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
    /*
    HYRedpacketDetailViewController *vc = [[HYRedpacketDetailViewController alloc] initWithNibName:@"HYRedpacketDetailViewController" bundle:nil];
    vc.redpacket = _redpacket;
    vc.recv = self.recv;
    [self.navigationController pushViewController:vc
                                         animated:YES];
     */
}

//到红包领取列表
- (void)checkList:(id)sender
{
    HYRPOtherListViewController *vc = [[HYRPOtherListViewController alloc] init];
    //vc.redpacket = rp;
    vc.redpacketCode = _redpacket.code;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

@end
