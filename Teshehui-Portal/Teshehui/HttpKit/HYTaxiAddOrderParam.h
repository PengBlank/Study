//
//  HYTaxiAddOrderParam.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYTaxiAddOrderParam : JSONModel

@property (nonatomic, strong) NSString* orderTotalAmount;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* cityCode;
@property (nonatomic, strong) NSString* cityName;
@property (nonatomic, strong) NSString* ruleCode;
@property (nonatomic, strong) NSString* ruleName;
@property (nonatomic, strong) NSString* carTypeCode;
@property (nonatomic, strong) NSString* comboId;
@property (nonatomic, strong) NSString* callCarType;
@property (nonatomic, strong) NSString* startTime;
@property (nonatomic, strong) NSString* passengerPhone;
@property (nonatomic, strong) NSString* startLatitude;
@property (nonatomic, strong) NSString* startLongitude;
@property (nonatomic, strong) NSString* startAddressName;
@property (nonatomic, strong) NSString* startAddressDetail;
@property (nonatomic, strong) NSString* endLatitude;
@property (nonatomic, strong) NSString* endLongitude;
@property (nonatomic, strong) NSString* endAddressName;
@property (nonatomic, strong) NSString* endAddressDetail;
@property (nonatomic, strong) NSString* currentLatitude;
@property (nonatomic, strong) NSString* currentLongitude;
@property (nonatomic, strong) NSString* mapType;
@property (nonatomic, strong) NSString* smsPolicy;

+ (instancetype)testData;

@end
