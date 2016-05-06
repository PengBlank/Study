//
//  HYTaxiOrder.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYTaxiOrder : JSONModel

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *orderShowStatus;
@property (nonatomic, assign) NSInteger buyerId;
@property (nonatomic, copy) NSString *didiOrderTotalAmount;
@property (nonatomic, copy) NSString *orderTotalAmount;
@property (nonatomic, copy) NSString *orderPayAmount;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *startAddressName;
@property (nonatomic, copy) NSString *didiOrderId;
@property (nonatomic, copy) NSString *didiOrderStatus;
@property (nonatomic, copy) NSString *endAddressName;
@property (nonatomic, copy) NSString *startLongitude;
@property (nonatomic, copy) NSString *endLongitude;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, copy) NSString *ruleCode;
@property (nonatomic, copy) NSString *carTypeCode;
@property (nonatomic, copy) NSString *passengerPhone;
@property (nonatomic, copy) NSString *endLatitude;
@property (nonatomic, copy) NSString *startLatitude;
@property (nonatomic, copy) NSString *orderId;

// 滴滴订单列表用到参数
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *ruleName;

@end


///** 滴滴订单状态:300等待应答,311 订单超时，400 等待接驾，410 司机已到达，500 行程中，600 行程结束，610 行程异常结束，700 已支付 */