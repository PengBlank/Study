//
//  HYPhoneChargeOrderListViewController.h
//  Teshehui
//
//  Created by HYZB on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

/**
  *  话费/流量充值订单列表
  */
@interface HYPhoneChargeOrderListViewController : HYMallViewBaseController

// 界面跳转传递的参数
@property (nonatomic, assign) NSInteger type; // 2 话费  5 流量;

@end
