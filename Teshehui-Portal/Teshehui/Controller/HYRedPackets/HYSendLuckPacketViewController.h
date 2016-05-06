//
//  HYSendLuckPacketViewController.h
//  Teshehui
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"
#import "HYRedpacketInfo.h"
#import "HYShareRedpacketReq.h"

/**
 *  @brief  发送手气红包（特令红包)
 */
@interface HYSendLuckPacketViewController : HYMallViewBaseController

@property (nonatomic, strong) HYShareRedpacketResp *sendedPacketInfo;
@property (nonatomic, strong) NSString *type;

@end
