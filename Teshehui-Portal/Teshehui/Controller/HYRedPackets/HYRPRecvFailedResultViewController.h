//
//  HYRPRecvFailedResultViewController.h
//  Teshehui
//
//  Created by HYZB on 15/3/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYRedpacketInfo.h"
#import "HYRedpacketRecv.h"

@interface HYRPRecvFailedResultViewController : HYMallViewBaseController

@property (nonatomic, weak) IBOutlet UIScrollView *contentView;
@property (nonatomic, weak) IBOutlet UIImageView *redpacketView;

@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet UILabel *descLab;
@property (nonatomic, weak) IBOutlet UILabel *timeLab;
@property (nonatomic, weak) IBOutlet UILabel *errMsgLab;
@property (nonatomic, weak) IBOutlet UIButton *checkBtn;

@property (nonatomic, strong) HYRedpacketInfo *redpacket;
@property (nonatomic, strong) HYRedpacketRecv *recv;

@end
