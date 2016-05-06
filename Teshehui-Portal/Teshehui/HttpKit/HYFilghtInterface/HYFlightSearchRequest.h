//
//  HYFlightSearchRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 机票查询
 */

#import "CQBaseRequest.h"
#import "HYFlightSearchResponse.h"
#import "HYCabins.h"

@interface HYFlightSearchRequest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *flightDate;  //搜索航班日期(时间戳)
@property (nonatomic, copy) NSString *startCityId;  //出发城市三字码
@property (nonatomic, copy) NSString *endCityId;  //到达城市三字码

//可选字段
@property (nonatomic, copy) NSString *isSupportChild;
@property (nonatomic, copy) NSString *airline;  //航空公司二字码
@property (nonatomic, strong) NSArray *cabinType;  //舱位类型筛选 F-头等舱 C-商务舱 Y-经济舱
@property (nonatomic, copy) NSString *highPrice;     //价格
@property (nonatomic, copy) NSString *lowPrice;
@property (nonatomic, copy) NSString *searchType;
@property (nonatomic, copy) NSString *orderBy;       //排序字段名
@property (nonatomic, copy) NSString *order;         //排序

@property (nonatomic, assign) NSInteger pageSize;   //分页
@property (nonatomic, assign) NSInteger pageNo;

@end
