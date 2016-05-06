//
//  HYMallOrderSummary.h
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

#import "HYAddressInfo.h"
#import "HYMallChildOrder.h"

typedef enum  _MallOrderHandleType{
    Payment_Order = 1,  //付款
    Cancel_Order,  //取消
    Delete_Order,  //删除
    RecvConfig_Order,  //确认收货
    Logistics,  //物流跟踪
    Commend,  //评价
    AddCommend,  //追评
    RemindStore,  //提醒发货
    CheckDetail,  //支持查看详情的情况
    Refounded,  //退换货
    ApplyAfterSaleService //申请售后
}MallOrderHandleType;


/**
 *  商城订单摘要
 */
@interface HYMallOrderSummary : JSONModel
{
    NSString *_createTime;
}

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *orderShowStatus;
@property (nonatomic, copy) NSString *buyerId;
@property (nonatomic, copy) NSString *discountAmount;
@property (nonatomic, copy) NSString *itemTotalAmount;
@property (nonatomic, copy) NSString *orderTbAmount;
@property (nonatomic, copy) NSString *orderTotalAmount;  //值同 points，为了解决后台不同的地方下单返回的特币字段不一致的问题
@property (nonatomic, copy) NSString *orderPayAmount;
@property (nonatomic, copy) NSString *orderActualAmount;
@property (nonatomic, copy) NSString *deliveryFee;
@property (nonatomic, copy) NSString *creationTime;
@property (nonatomic, copy) NSString *cancelTime;
@property (nonatomic, assign) NSInteger isApplyCancel;
@property (nonatomic, strong) HYAddressInfo  *address;  //收货地址
@property (nonatomic, copy) NSString *statusDesc;

//新增
@property (nonatomic, copy) NSArray<HYMallChildOrder> *orderItem;

@end
