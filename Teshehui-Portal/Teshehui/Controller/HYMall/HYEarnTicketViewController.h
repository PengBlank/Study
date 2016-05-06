//
//  HYEarnTicketViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYTabbarViewController.h"

/**
 *  老版赚现金券
 *
 */
@interface HYEarnTicketViewController : HYMallViewBaseController

@property (nonatomic, weak) HYTabbarViewController *baseViewController;

/// 获取相应的子视图
//+ (UIViewController *)chilControllerForBuisinessType:(NSString *)buisinessType;
//- (void)checkBusinessType:(NSString *)buisinessType;

@end
