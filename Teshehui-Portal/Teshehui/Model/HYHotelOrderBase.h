//
//  HYHotelOrder.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 * 酒店订单对象
 */

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"
#import "JSONModel.h"

typedef enum _HotelOrderStatus
{
    User_Delete = -99,
    Pending_Local = 0,
    Pending_Ramote = 1,
    Processing = 2,
    Confirmed = 4,
    Cancel = 8,
    Sucesse = 16,
    Failed = -1,
    Unpaid = 32,  //未付款
    Paid = 64 //已付款
}HotelOrderStatus;

/*
 id	INT	订单ID
 order_no	STRING	订单NO.
 user_id	INT	商城用户ID
 retry_time	INT	去携程生成订单的次数，最多3次，超过3次后不再去携程生成订单，即订单生成失败
 updated	INT	订单最后更新时间，时间截格式
 created	INT	订单生成时间，时间截格式
 status	INT	订单状态
0 待处理 - 本地
 1 待处理 - 携程
 2 处理中
 4 已确认
 8 已取消
 16 已成功
 -1 下单失败
 32 未付款
 64 已付款
 contract	INT	是否扣违约金
 1 已入住 - 不扣
 2 已离店 - 不扣
 3 noshow - 要扣除违约金
 */

@interface HYHotelOrderBase : JSONModel

@property (nonatomic, copy) NSString *updated;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, assign) HotelOrderStatus status;
@property (nonatomic, copy) NSString *orderShowStatus;
@property (nonatomic, assign) int contract;
//@property (nonatomic, assign) CGFloat amount_before_tax;  //总价

@property (nonatomic, readonly, copy) NSString *orderStatusDesc;
@property (nonatomic, assign) NSInteger orderType;

//新字段
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderTotalAmount;
@property (nonatomic, copy) NSString *productTypeCode;
@property (nonatomic, copy) NSString *orderCash;
@property (nonatomic, copy) NSString *walletAmount;
@property (nonatomic, copy) NSString *walletStatus;

@property (nonatomic, copy) NSString *buyerNick;//在订单详情里面才有的信息
@property (nonatomic, copy) NSString *buyerId;

- (BOOL)isPrePay;

@end


