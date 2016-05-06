//
//  HYFlightLIstSummary.h
//  Teshehui
//
//  Created by HYZB on 15/5/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductListSummary.h"

@interface HYFlightListSummary : HYProductListSummary

@property (nonatomic, copy) NSString *fId;
@property (nonatomic, copy) NSString *endCityId;
@property (nonatomic, copy) NSString *startCityId;
@property (nonatomic, copy) NSString *endCityName;
@property (nonatomic, copy) NSString *startCityName;
@property (nonatomic, copy) NSString *endPortName;
@property (nonatomic, copy) NSString *startPortName;
@property (nonatomic, copy) NSString *airlineCode;
@property (nonatomic, copy) NSString *airlineName;
@property (nonatomic, copy) NSString *cabinName;
@property (nonatomic, copy) NSString *flightNo;
@property (nonatomic, copy) NSString *flightDate;
@property (nonatomic, copy) NSString *startTerminal;
@property (nonatomic, copy) NSString *endTerminal;
@property (nonatomic, copy) NSString *startDatetime;
@property (nonatomic, copy) NSString *endDatetime;
@property (nonatomic, copy) NSString *planeType;
@property (nonatomic, assign) NSInteger during;
@property (nonatomic, assign) NSInteger isMeal;

@property (nonatomic, copy) NSString *isShare;  
@property (nonatomic, assign) NSInteger stopTimes;
@property (nonatomic, copy) NSString *carrierCompany;
@property (nonatomic, assign) NSInteger sourceFrom;
@property (nonatomic, copy) NSString *expiredDatetime;
@property (nonatomic, copy) NSString *updatedDatetime;
@property (nonatomic, copy) NSString *createdDatetime;
@property (nonatomic, copy) NSString *opionset;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *discount;


@property (nonatomic, assign, readonly) NSTimeInterval startTimestamp;

@end

/*
 "id":"8236",
 "endCityId":"SZX",
 "startCityId":"PEK",
 "endCityName":null,
 "startCityName":null,
 "endPortName":null,
 "startPortName":null,
 "airlineCode":"CA",
 "flightNo":"CA1305",
 "flightDate":"1432742400",
 "startTerminal":"T3",
 "endTerminal":"T3",
 "startDatetime":"2015-05-28 18:25:00",
 "endDatetime":"2015-05-28 21:50:00",
 "during":205,
 "isMeal":"1",
 "planeType":"330",
 "stopTimes":0,
 "isShare":"0",
 "carrierCompany":"CA",
 "currencyCode":"CNY",
 "sourceFrom":4,
 "expiredDatetime":"2015-05-25 16:16:07",
 "updatedDatetime":"1970-01-01 08:00:00",
 "createdDatetime":"2015-05-23 01:24:11",
 "opionset":"0",
 "status":"0"
*/
