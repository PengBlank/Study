//
//  HYTaxiOrderListModel.h
//  Teshehui
//
//  Created by HYZB on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
// #import "HYTaxiOrderListExpandedModel.h"


@interface HYTaxiOrderListModel : JSONModel

@property (nonatomic, copy) NSString *didiOrderId;
@property (nonatomic, copy) NSString *didiOrderStatus;
@property (nonatomic, copy) NSString *ruleCode;
@property (nonatomic, copy) NSString *carTypeCode;
@property (nonatomic, copy) NSString *passengerPhone;
@property (nonatomic, copy) NSString *startLatitude;
@property (nonatomic, copy) NSString *startLongitude;
@property (nonatomic, copy) NSString *startAddressName;
@property (nonatomic, copy) NSString *endLatitude;
@property (nonatomic, copy) NSString *endLongitude;
@property (nonatomic, copy) NSString *endAddressName;
@property (nonatomic, copy) NSString *didiOrderTotalAmount;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, copy) NSString *ruleName;
// @property (nonatomic, strong) HYTaxiOrderListExpandedModel *expandedResponse;
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *orderShowStatus;
@property (nonatomic, assign) NSInteger buyerId;
@property (nonatomic, copy) NSString *orderTotalAmount;

/*
 "didiOrderId":"6133323331590966657",
 "didiOrderStatus":"300",
 "ruleCode":"301",
 "carTypeCode":"600",
 "passengerPhone":"15171466149",
 "startLatitude":"22.531159",
 "startLongitude":"114.021877",
 "startAddressName":"雪松大厦B座",
 "endLatitude":"22.540759",
 "endLongitude":"22.540759",
 "endAddressName":"南山公安分局",
 "didiOrderTotalAmount":"26",
 "createdTime":"2015-11-24 19:07:21",
 "orderStatus":300,
 "orderId":57,
 "orderCode":"DCN3W07244046",
 "status":10,
 "orderShowStatus":"进行中",
 "buyerId":64492,
 "orderTotalAmount":"2600"
 */

@end
