//
//  HYRPOtherListViewController.h
//  Teshehui
//
//  Created by apple on 15/3/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  @brief  已领完查看其他列表
 */
#import "HYMallViewBaseController.h"
#import "HYRedpacketInfo.h"
@interface HYRPOtherListViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

//@property (nonatomic, assign) BOOL isShowSend;
@property (nonatomic, strong) HYRedpacketInfo *packetDetail;
//@property (nonatomic, strong) HYRedpacketInfo *redpacketSum;

@property (nonatomic, strong) NSString *redpacketCode;
@end
