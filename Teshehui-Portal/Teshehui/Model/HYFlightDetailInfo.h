//
//  CQflightDetail.h
//  Teshehui
//
//  Created by ChengQian on 13-11-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYProductDetailSummary.h"
#import "HYCabins.h"
#import "HYFlightSKU.h"

@interface HYFlightDetailInfo : HYProductDetailSummary

@property (nonatomic, copy) NSString *endCityCode;
@property (nonatomic, copy) NSString *startCityCode;
@property (nonatomic, copy) NSString *endCityName;
@property (nonatomic, copy) NSString *startCityName;
@property (nonatomic, copy) NSString *endAirportName;
@property (nonatomic, copy) NSString *startAirportName;
@property (nonatomic, copy) NSString *airlineCode;
@property (nonatomic, copy) NSString *airlineName;
@property (nonatomic, copy) NSString *flightNo;
@property (nonatomic, copy) NSString *flightDate;
@property (nonatomic, copy) NSString *startAirportTerminal;
@property (nonatomic, copy) NSString *endAirportTerminal;
@property (nonatomic, copy) NSString *startDatetime;
@property (nonatomic, copy) NSString *endDatetime;
@property (nonatomic, copy) NSString *planeType;
@property (nonatomic, assign) NSInteger during;
@property (nonatomic, assign) NSInteger isMeal;
@property (nonatomic, assign) NSInteger stopTimes;
@property (nonatomic, copy) NSString *carrierCompanyName;
@property (nonatomic, copy) NSString *updatedTime;
@property (nonatomic, copy) NSString *createdTime;

- (id)initWithDictionary:(NSDictionary *)dict;

@end

/*


 "carrierCompanyName":null,
 "updatedTime":null,
 "createdTime":null":null,
 
*/