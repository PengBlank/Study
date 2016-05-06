//
//  HYRPPersonInsertViewController.h
//  Teshehui
//
//  Created by apple on 15/3/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"
/**
 *  @brief  红包直接输入用户
 */
@interface HYRPPersonInsertViewController : HYMallViewBaseController

@property (nonatomic, copy) void (^insertCallback)(NSString *name);

@end
