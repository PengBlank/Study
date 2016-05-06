//
//  HYTaxiService.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYTaxiAddOrderParam.h"
#import "HYTaxiOrderView.h"
#import "HYTaxiOrder.h"
#import "HYTaxiCancelOrderResp.h"

typedef void(^HYTaxiServiceCallback)(NSString *err);
typedef void(^HYTaxiServiceCallback2)(NSString *err, HYTaxiOrderView *orderView);
typedef void(^HYTaxiServiceCallback3)(NSString *err, HYTaxiOrder *order);
typedef void(^HYTaxiServiceCallback4)(NSString *err, HYTaxiCancelResult *cancelResult);

@interface HYTaxiService : NSObject

- (void)addOrder:(HYTaxiAddOrderParam *)param withCallback:(HYTaxiServiceCallback3)callback;

/**
 *  取消订单
 *
 *  @param orderCode 订单号
 *  @param force     是否强制
 *  @param callback  回调
 */
- (void)cancelOrder:(NSString *)orderCode
            isForce:(BOOL)force
       withCallback:(HYTaxiServiceCallback4)callback;

/**
 *  重新叫车
 *
 *  @param orderId
 *  @param callback
 */
- (void)callCarAgain:(NSString *)orderId withCallback:(HYTaxiServiceCallback)callback;

/**
 *  实时获取订单信息
 *
 *  @param orderId
 *  @param callback
 */
- (void)getOrderInfoRealTime:(NSString *)orderId
                withCallback:(HYTaxiServiceCallback2)callback;

/**
 *  获取订单详情
 *  这里获取的订单详情是订单系统的订单, 用于支付及订单列表
 *
 *  @param orderId
 *  @param orderCode
 *  @param userId
 *  @param enterprise
 *  @param callback
 */
- (void)getOrderInfoWithOrderId:(NSString *)orderId
                      orderCode:(NSString *)orderCode
                         userId:(NSString *)userId
                     enterprise:(BOOL)enterprise
                       callback:(HYTaxiServiceCallback3)callback;

@end

@interface UIViewController (HYTaxiService)

@property (nonatomic, strong) HYTaxiService *taxiService;

@end
