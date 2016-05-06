//
//  HYPaymentViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 支付界面
 */



#import "HYBaseDetailViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "DataVerifier.h"
#import "UPPayPlugin.h"
#import "WXApi.h"
#import "HYAlipayOrder.h"

@class HYQuickActive2ViewController;

@interface HYPaymentViewController : HYBaseDetailViewController
<
UITableViewDataSource,
UITableViewDelegate,
UPPayPluginDelegate
>

@property (nonatomic, assign) CGFloat amountMoney;  //需要支付的金额
@property (nonatomic, assign) ProductPayType type;  //物品的类型
@property (nonatomic, strong) HYAlipayOrder *alipayOrder;  //支付宝的订单对象
@property (nonatomic, copy) NSString *transactionNO;  //银联支付的流水号
@property (nonatomic, copy) NSString *orderID;  //订单的id,在没有银联的流水号的时候，需要根据订单ID去获取
@property (nonatomic, copy) NSString *orderNO;  //订单号

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, weak) HYQuickActive2ViewController *pre_vc;


@end
