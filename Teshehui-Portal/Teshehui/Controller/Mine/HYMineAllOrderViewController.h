//
//  HYMineAllOrderViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

/**
 *  @brief 订单列表
 *  新版订单列表界面可以在不同类型订单之间跳转
 *  这里的controller仅作为一个容器
 */
@interface HYMineAllOrderViewController : HYMallViewBaseController

- (void)showOrderViewController:(UIViewController *)orderViewcontroller;

- (UIViewController *)showOrderViewWithType:(BusinessType)type;

@end
