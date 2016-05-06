//
//  HYRPRecvDetailViewController.h
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 * 红包领取情况
 */

#import "HYMallViewBaseController.h"
#import "HYRedpacketInfo.h"

@interface HYRPRecvDetailViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign) BOOL isShowSend;
@property (nonatomic, strong) HYRedpacketInfo *packetDetail;
//@property (nonatomic, strong) HYRedpacketInfo *redpacketSum;

@property (nonatomic, strong) NSString *redpacketCode;
@property (nonatomic, assign) BOOL isLuck;

@end
