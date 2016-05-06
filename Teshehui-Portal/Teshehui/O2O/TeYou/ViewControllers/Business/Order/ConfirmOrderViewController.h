//
//  ConfirmOrderViewController.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/**
    O2O附近商家确认订单页(扫码)
 **/

#import "HYMallViewBaseController.h"
#import "HYTabbarViewController.h"

#import "OrderInfo.h"
@interface ConfirmOrderViewController : HYMallViewBaseController

@property (nonatomic,assign) BOOL       pageType;   //针对不同页面跳转  进行不同方式的pop
@property (nonatomic,strong) OrderInfo  *orderInfo;
@property (nonatomic,strong) NSString   *storeName;     //商店名称
@property (nonatomic,strong) NSString   *payMoney;      //消费金额
@property (nonatomic,strong) NSString   *payCoupon;     //消费现金券

@property (nonatomic, weak) HYTabbarViewController *baseViewController;

@end
