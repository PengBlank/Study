//
//  HYTaxiService.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiService.h"
#import "HYTaxiAddOrderRequest.h"
#import "HYTaxiCancelOrderReq.h"
#import "HYTaxiCallCarAgainReq.h"
#import "HYTaxiGetDidiOrderInfoReq.h"
#import "HYTaxiGetOrderInfoRequest.h"

#import <objc/runtime.h>

@implementation HYTaxiService
{
    HYTaxiAddOrderRequest *_addRequest;
    HYTaxiCancelOrderReq *_cancelReq;
    HYTaxiCallCarAgainReq *_againReq;
    HYTaxiGetDidiOrderInfoReq *_infoReq;
    HYTaxiGetOrderInfoRequest *_orderInfoReq;
}

- (void)dealloc
{
    [_addRequest cancel];
    [_cancelReq cancel];
    [_againReq cancel];
    [_infoReq cancel];
    [_orderInfoReq cancel];
}

- (void)addOrder:(HYTaxiAddOrderParam *)param withCallback:(HYTaxiServiceCallback3)callback
{
    _addRequest = [[HYTaxiAddOrderRequest alloc] init];
    _addRequest.param = param;
    [_addRequest sendReuqest:^(id result, NSError *error)
     {
         if ([result isKindOfClass:[HYTaxiAddOrderResponse class]] &&
             [(HYTaxiAddOrderResponse *)result status] == 200)
         {
             callback(nil, [result order]);
         }
         else
         {
             callback(error.domain, nil);
         }
    }];
}

/**
 *  取消订单
 *
 *  @param orderCode 订单号
 *  @param force     是否强制
 *  @param callback  回调
 */
- (void)cancelOrder:(NSString *)orderCode
            isForce:(BOOL)force
       withCallback:(HYTaxiServiceCallback4)callback
{
    if (_cancelReq) {
        [_cancelReq cancel];
    }
    _cancelReq = [[HYTaxiCancelOrderReq alloc] init];
    _cancelReq.orderCode = orderCode;
    _cancelReq.isForceCancel = force;
    [_cancelReq sendReuqest:^(id result, NSError *error)
    {
        if ([result isKindOfClass:[HYTaxiCancelOrderResp class]] &&
            [(HYTaxiCancelOrderResp *)result status] == 200)
        {
            callback(nil, [(HYTaxiCancelOrderResp *)result cancelResult]);
        }
        else
        {
            callback(error.domain, nil);
        }
    }];
}

/**
 *  重新叫车
 *
 *  @param orderId
 *  @param callback
 */
- (void)callCarAgain:(NSString *)orderId withCallback:(HYTaxiServiceCallback)callback
{
    if (_againReq) {
        [_againReq cancel];
    }
    _againReq = [[HYTaxiCallCarAgainReq alloc] init];
    _againReq.didiOrderId = orderId;
    [_againReq sendReuqest:^(id result, NSError *error) {
        if ([result isKindOfClass:[HYTaxiCallCarAgainResp class]] &&
            [(HYTaxiCallCarAgainResp *)result status] == 200)
        {
            if (callback)
            {
                callback(nil);
            }
        }
        else
        {
            if (callback)
            {
                callback(error.domain);
            }
        }
    }];
}

/**
 *  实时获取订单信息
 *
 *  @param orderId
 *  @param callback
 */
- (void)getOrderInfoRealTime:(NSString *)orderId
                withCallback:(HYTaxiServiceCallback2)callback
{
    if (_infoReq) {
        [_infoReq cancel];
    }
    _infoReq = [[HYTaxiGetDidiOrderInfoReq alloc] init];
    _infoReq.didiOrderId = orderId;
    [_infoReq sendReuqest:^(id result, NSError *error)
     {
         if ([result isKindOfClass:[HYTaxiGetDidiOrderInfoResp class]] &&
             [(HYTaxiGetDidiOrderInfoResp *)result status] == 200)
         {
             callback(nil, [(HYTaxiGetDidiOrderInfoResp *)result orderView]);
         }
         else
         {
             callback(error.domain, nil);
         }
    }];
}

- (void)getOrderInfoWithOrderId:(NSString *)orderId orderCode:(NSString *)orderCode userId:(NSString *)userId enterprise:(BOOL)enterprise callback:(HYTaxiServiceCallback3)callback
{
    if (_orderInfoReq) {
        [_orderInfoReq cancel];
    }
    _orderInfoReq = [[HYTaxiGetOrderInfoRequest alloc] init];
    _orderInfoReq.orderId = orderId;
    _orderInfoReq.orderCode = orderCode;
    _orderInfoReq.userUserId = userId;
    _orderInfoReq.isEnterprise = enterprise;
    [_orderInfoReq sendReuqest:^(id result, NSError *error)
    {
        if ([result isKindOfClass:[HYTaxiGetOrderInfoResponse class]] &&
            [(HYTaxiGetOrderInfoResponse *)result status] == 200)
        {
            HYTaxiGetOrderInfoResponse *rs = (HYTaxiGetOrderInfoResponse *)result;
            callback(nil, rs.orderInfo);
        }
        else
        {
            callback(error.domain, nil);
        }
    }];
}

@end

static unichar taxiServiceKey;

@implementation UIViewController (HYTaxiService)

- (HYTaxiService *)taxiService
{
    HYTaxiService *service = objc_getAssociatedObject(self, &taxiServiceKey);
    if (!service)
    {
        service = [[HYTaxiService alloc] init];
        objc_setAssociatedObject(self, &taxiServiceKey, service, OBJC_ASSOCIATION_RETAIN);
    }
    return service;
}

- (void)setTaxiService:(HYTaxiService *)taxiService
{
    //empty
}

@end
