//
//  HYGroupOrderInfo.h
//  Teshehui
//
//  Created by HYZB on 2014/12/17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"
#import "HYGroupOrderDetailInfo.h"

@interface HYGroupOrderInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *localOrderId;
@property (nonatomic, copy) NSString *buyerId;
@property (nonatomic, copy) NSString *thirdOrderId;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *orderFrom;
@property (nonatomic, copy) NSString *orderCreateTime;
@property (nonatomic, assign) float itemAmount;
@property (nonatomic, assign) float orderAmount;
@property (nonatomic, assign) float actualAmount;
@property (nonatomic, copy) NSString *payStatus;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, assign) BOOL whetherTebi;  //0未送 1 已送
@property (nonatomic, copy) NSString *whetherSettlement;
@property (nonatomic, copy) NSString *orderUpdateTime;
@property (nonatomic, copy) NSString *agencyId;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *promotersId;
@property (nonatomic, assign) int points;
@property (nonatomic, strong) HYGroupOrderDetailInfo *orderDetail;

@end


/*
 localOrderId	INT	本地订单ID(预留)
 buyerId	STRING	用户ID
 thirdOrderId	STRING	美团订单ID（第三方订单ID）
 orderCreateTime	STRING	订单时间，格式：yyyy-MM-dd hh:mm:ss
 orderType	STRING	订单类型：优惠卷 coupon，物流单 delivery，二维码voucher等
 orderFrom	STRING	订单来源，PC,MOBILE,WAP
 orderCreateTime	STRING	订单创建时间
 orderCancelTime	STRING	订单取消时间
 deliverType	STRING	发货方式    0 普通   1供应商直发(预留)
 orderDeliverAddress	STRING	收货地址(预留)
 lpType	STRING	物流类型(预留)
 buyerMessage	STRING	买家留言(预留)
 itemAmount	DOUBLE	商品总金额
 orderAmount	DOUBLE	订单总金额（商品总金额+运费）
 actualAmount	DOUBLE	实际付款金额
 payType	STRING	支付类型(预留)
 payStatus	STRING	支付状态：已支付=P，未支付=N
 orderStatus	STRING	订单状态：已付款，已消费，已退款，已下单
 lpStatus	STRING	订单物流状态：  1-备货中   2-部分发货   3-已发货(预留)
 whetherTebi	STRING	是否已赠送现金券
 whetherSettlement	STRING	是否已结算
 orderUpdateTime	STRING	修改时间
 invoiceId	STRING	发票ID(预留)
 orderDetail	OrderDetail	订单详情
*/