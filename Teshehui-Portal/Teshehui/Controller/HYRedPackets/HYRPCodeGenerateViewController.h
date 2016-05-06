//
//  HYRPCodeGenerateViewController.h
//  Teshehui
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYRedpacketInfo.h"
#import "HYMallViewBaseController.h"
/**
 *  @brief  红包特令生成界面，即效果图“群红包”
 */
@interface HYRPCodeGenerateViewController : HYMallViewBaseController

@property (nonatomic, strong) HYRedpacketInfo *packetInfo;

@end
