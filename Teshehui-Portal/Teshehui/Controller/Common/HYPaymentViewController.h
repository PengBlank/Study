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

#import "HYCustomNavItemViewController.h"
#import <AlipaySDK/AlipaySDK.h>

#import "HYAddressInfo.h"
#import "UPPayPlugin.h"
#import "WXApi.h"
#import "HYAlipayOrder.h"

#import "DefineConfig.h"
@class HYPaymentViewController;

typedef void(^paymentResultCallBack)(BOOL finished, NSError *error);

typedef void(^PaymentCallback)(HYPaymentViewController *payvc, id order);
typedef void(^PaymentCancelCallback)(HYPaymentViewController *payvc);

@interface HYPaymentViewController : HYCustomNavItemViewController
<
UITableViewDataSource,
UITableViewDelegate,
UPPayPluginDelegate
>

@property (nonatomic, copy) NSString *payMoney;  //待支付的金额
@property (nonatomic, copy) NSString *amountMoney;  //订单总金额
@property (nonatomic, assign) CGFloat point;  //现金券
@property (nonatomic, assign) ProductPayType type;  //物品的类型
@property (nonatomic, strong) HYAlipayOrder *alipayOrder;  //支付宝的订单对象
@property (nonatomic, copy) NSString *transactionNO;  //银联支付的流水号
@property (nonatomic, copy) NSString *orderID;  //订单的id,在没有银联的流水号的时候，需要根据订单ID去获取
@property (nonatomic, copy) NSString *orderCode;  //订单号
@property (nonatomic, copy) NSString *originCode;
@property (nonatomic, copy) NSString *productDesc;

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong) HYAddressInfo *adressInfo;

//@property (nonatomic, copy  ) NSString  *O2O_OrderNo;//O2O中心的订单号
//@property (nonatomic, copy  ) NSString  *O2O_storeName;//O2O中心付款商家名称
@property (nonatomic, assign) NSInteger O2OpayType;//O2O支付类型
//@property (nonatomic, assign) BOOL      o2oIsPay;
@property (nonatomic, copy) void                  (^travelTicketsPaymentSuccess)();//旅游门票支付成功 结果是已经成功的，所以是无参的
@property (nonatomic, copy) void                  (^businessPaymentSuccess)(O2OPayType type);


/**
 *  现在支付界面已经太乱
 *  新增的滴滴打车只使用支付的过程, 其他的流程均在回调中完成
 *  回调中加入各种参数, 方便调用者使用
 *  增加回调后, 现在对结果的判断改为:如果有回调就仅执行回调, 否则执行原来的逻辑
 */
@property (nonatomic, copy) PaymentCallback paymentCallback;

/**
 *  这个回调后期应该被删除
 */
@property (nonatomic, copy) paymentResultCallBack payCallback;  //订单号


/**
 *  返回时的回调,同上
 */
@property (nonatomic, copy) PaymentCancelCallback cancelCallback;

@end
