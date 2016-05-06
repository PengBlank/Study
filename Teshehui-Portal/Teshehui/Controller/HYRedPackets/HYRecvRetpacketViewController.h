//
//  HYRecvRetpacketViewController.h
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *拆红包界面
 */
#import "HYMallViewBaseController.h"
#import "HYRedpacketInfo.h"

@interface HYRecvRetpacketViewController : HYMallViewBaseController

@property (nonatomic, weak) IBOutlet UIImageView *footerView;
@property (nonatomic, weak) IBOutlet UIImageView *redpacketView;
@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet UILabel *descLab;
@property (nonatomic, weak) IBOutlet UIButton *recvBtn;

@property (nonatomic, strong) HYRedpacketInfo *redpacket;

- (IBAction)recvRedpacket:(id)sender;

@property (nonatomic, copy) void (^redpacketRecvCallback)(BOOL success);

@end
