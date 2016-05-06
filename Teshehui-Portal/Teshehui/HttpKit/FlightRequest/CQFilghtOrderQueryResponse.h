//
//  CQFilghtOrderQueryResponse.h
//  ComeHere
//
//  Created by ChengQian on 13-11-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQBaseResponse.h"
#import "CQFilghtOrder.h"

@interface CQFilghtOrderQueryResponse : CQBaseResponse

@property (nonatomic, assign) int RecordCount;
@property (nonatomic, assign) int CurrentPage;
@property (nonatomic, assign) int PageCount;
@property (nonatomic, strong) NSArray *orderList;

/*
 "Status": "0",
 "RecordCount": "26",
 "CurrentPage": "3",
 "PageCount": "6",
 "DataList": [
 {
 "OrderID": "635204964569409792",
 "PmOrderID": "",
 "FlightType": "1",
 "StartCity": "深圳机场",
 "StartCityT": "B",
 "EndCity": "北京首都机场",
 "EndCityT": "T3",
 "CabinCode": "Y",
 "DisCount": "",
 "Carrier": "深圳航空",
 "FlightDate": "2013-11-20",
 "StartTime": "10:05",
 "EndTime": "13:05",
 "AirJX": "739",
 "TicketPrice": "1750.00",
 "CostPrice": "0",
 "SumPrice": "1920.0",
 "SpecialType": "1",
 "OrderStatus": "0",
 "IsChild": "0"
 },
 */

@end
