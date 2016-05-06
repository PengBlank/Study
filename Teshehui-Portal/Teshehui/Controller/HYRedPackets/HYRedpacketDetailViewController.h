//
//  HYRedpacketDetailViewController.h
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *红包详情
 */

#import "HYMallViewBaseController.h"
#import "HYRedpacketInfo.h"
#import "HYRedpacketRecv.h"

@interface HYRedpacketDetailViewController : HYMallViewBaseController

@property (nonatomic, weak) IBOutlet UIScrollView *contentView;
@property (nonatomic, weak) IBOutlet UIImageView *redpacketView;

@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet UILabel *descLab;
@property (nonatomic, weak) IBOutlet UILabel *timeLab;
@property (nonatomic, weak) IBOutlet UILabel *pointLab;
@property (nonatomic, weak) IBOutlet UIButton *returnBtn;
@property (nonatomic, weak) IBOutlet UIButton *shareBtn;
@property (nonatomic, weak) IBOutlet UIButton *sendBtn;

@property (nonatomic, strong) HYRedpacketInfo *redpacket;
@property (nonatomic, strong) HYRedpacketRecv *recv;

@property (nonatomic, assign) BOOL isRecvPacket;    //是否从领红包界面进入


- (IBAction)returnNewRedpacket:(id)sender;
- (IBAction)shareToFriends:(id)sender;
- (IBAction)sendRedpacket:(id)sender;

@end
