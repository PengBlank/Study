//
//  HYUpgradeAlertView.h
//  Teshehui
//
//  Created by 成才 向 on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CCPopoverView.h"
#import "HYMallViewBaseController.h"
#import "HYUserService.h"
#import "HYSiRedPacketsViewController.h"
#import "HYUpdateToOfficialUserViewController.h"
#import "HYPaymentViewController.h"

@interface HYUpgradeAlertView : CCPopoverView

@property (nonatomic, copy) void (^handler)(NSInteger buttonIndex);

@property (nonatomic, strong) HYUserService *userService;

@property (nonatomic, copy) void (^controllerHandler)(HYUpdateToOfficialUserViewController *updateController, HYPaymentViewController *paymentController);

@end
