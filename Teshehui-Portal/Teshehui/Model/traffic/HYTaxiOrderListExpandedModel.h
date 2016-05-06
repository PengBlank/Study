//
//  HYTaxiOrderListExpandedModel.h
//  Teshehui
//
//  Created by HYZB on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYTaxiOrderListExpandedModel : JSONModel

@property (nonatomic, copy) NSString *didiOrderId;
@property (nonatomic, copy) NSString *didiOrderStatus;
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
@property (nonatomic, copy) NSString *ruleName;

@end
