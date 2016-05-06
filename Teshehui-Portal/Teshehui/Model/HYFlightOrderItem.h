//
//  HYFightOrderItem.h
//  Teshehui
//
//  Created by 成才 向 on 15/5/29.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYFlightOrderItem <NSObject>

@end

@interface HYFlightOrderItem : JSONModel

@property (nonatomic, strong) NSString *ticketNo;
@property (nonatomic, strong) NSString *flightNo;
@property (nonatomic, strong) NSString *flightDate;
@property (nonatomic, strong) NSString *takeOffTime;
@property (nonatomic, strong) NSString *arrivalTime;
@property (nonatomic, strong) NSString *airlineCode;
@property (nonatomic, strong) NSString *airlineName;
@property (nonatomic, strong) NSString *orgCityName;
@property (nonatomic, strong) NSString *dstCityName;
@property (nonatomic, strong) NSString *orgAirportCode;
@property (nonatomic, strong) NSString *dstAirportCode;
@property (nonatomic, strong) NSString *orgAirportName;
@property (nonatomic, strong) NSString *dstAirportName;
@property (nonatomic, strong) NSString *orgAirportTerminal;
@property (nonatomic, strong) NSString *dstAirportTerminal;
@property (nonatomic, strong) NSString *cabinCode;
@property (nonatomic, strong) NSString *cabinType;
@property (nonatomic, assign) NSInteger cabinLevel;
@property (nonatomic, strong) NSString *cabinName;
@property (nonatomic, strong) NSString *cabinDesc;
@property (nonatomic, strong) NSString *passengerType;
@property (nonatomic, assign) CGFloat parPrice;
@property (nonatomic, assign) CGFloat fuelTax;
@property (nonatomic, assign) CGFloat airportTax;
@property (nonatomic, assign) NSInteger source;
@property (nonatomic, assign) NSInteger isBuyInsurance;
@property (nonatomic, assign) NSInteger isAllowPnr;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat points;
@property (nonatomic, assign) NSInteger quantity;

/**
 "ticketNo":"",
 "flightNo":"CA1305",
 "flightDate":"2015-05-28 00:00:00",
 "takeOffTime":"18:25",
 "arrivalTime":"21:50",
 "airlineCode":"",
 "airlineName":"国航",
 "orgCityName":"北京",
 "dstCityName":"深圳",
 "orgAirportCode":"PEK",
 "dstAirportCode":"SZX",
 "orgAirportName":"首都机场",
 "dstAirportName":"宝安国际机场",
 "orgAirportTerminal":"T3",
 "dstAirportTerminal":"T3",
 "cabinCode":"F",
 "cabinType":"F",
 "cabinLevel":0,
 "cabinName":"头等舱",
 "cabinDesc":"",
 "passengerType":"",
 "parPrice":5790,
 "fuelTax":0,
 "airportTax":50,
 "source":0,
 "isBuyInsurance":0,
 "isAllowPnr":0,
 "price":5633,
 "points":5683,
 "quantity":1
 */

@end
