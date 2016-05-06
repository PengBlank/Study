//
//  HYPhoneChargeOrderListModel.h
//  Teshehui
//
//  Created by HYZB on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYPhoneChargeOrderListModel : JSONModel


@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *thirdOrderCode;
@property (nonatomic, assign) NSInteger payStatus;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, assign) NSInteger pointType;
@property (nonatomic, assign) NSInteger pointStatus;

@property (nonatomic, copy) NSString *createTimeStr;
@property (nonatomic, copy) NSString *updateTimeStr;

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userTelephone;

@property (nonatomic, assign) NSInteger rechargeType;
@property (nonatomic, copy) NSString *rechargeTelephone;
@property (nonatomic, assign) NSInteger rechargeAmount;
@property (nonatomic, assign) NSInteger rechargeFlow;
@property (nonatomic, assign) NSInteger payType;

@property (nonatomic, copy) NSString *cashCoupon;

@property (nonatomic, copy) NSString *orderTradeAmount;
@property (nonatomic, copy) NSString *notPayAmount;

@property (nonatomic, copy) NSString *productName;

/*
 Long    orderId;           // id 序号
 String  orderCode;         // 本地订单编号
 String  thirdOrderCode;   // 第三方订单编码// 第三方订单号
 
 Integer payStatus;         // 支付状态
 Integer orderStatus;      // 订单状态
 
 Integer pointType;         // 特币类型
 Integer pointStatus;       // 特币赠送状态
 
 String  createTimeStr;     // 下单时间
 String  updateTimeStr;     // 修改时间
 
 Long    userId;            // 会员ID
 String  userName;          // 会员姓名
 String  userTelephone;     // 会员电话

 Integer rechargeType;      // 充值类型
 String  rechargeTelephone; // 充值电话
 Long    rechargeAmount;    // 面值
 
 Long    payType;           // 支付方式
 Long       rechargeFlow;//充值流量
 
 String  cashCoupon; //现金券
 String orderTradeAmount;    //总订单金额
 String notPayAmount;    //待支付订单金额
 
 String  productName;     // 商品名称
 */

@end
