//
//  CQCabins.h
//  Teshehui
//
//  Created by ChengQian on 13-11-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

//仓位信息
#import "JSONModel.h"

typedef enum _CabinType
{
    All_Cabin = 0,
    First_Cabin = 1,
    Business_Cabin = 2,
    Economy_Cabin = 3,
}CabinType;

@interface HYCabins : JSONModel

/** 航班舱位标识 */
@property (nonatomic, copy) NSString *cabinId;
/** 航班标识 */
@property (nonatomic, copy) NSString *flightId;
/** 舱位类型 */
@property (nonatomic, copy) NSString *cabinType;
@property (nonatomic, assign) CabinType type;
/** 舱位编码 */
@property (nonatomic, copy) NSString *cabinCode;
/** 舱位名称 */
@property (nonatomic, copy) NSString *cabinName;
/** 舱位库存 */
@property (nonatomic, assign) NSInteger stock;
/** 舱位折扣率 */
@property (nonatomic, copy) NSString *discount;
/** 舱位价格 */
@property (nonatomic, assign) CGFloat cabinTypePrice;
/** 单程票价 */
@property (nonatomic, assign) CGFloat singlePrice;
/** 往返票全价 */
@property (nonatomic, assign) CGFloat roundFullPrice;
/** 返利 */
@property (nonatomic, assign) CGFloat profit;
/** 往返票价 */
@property (nonatomic, assign) CGFloat roundPrice;
/** 往返返利 */
@property (nonatomic, assign) CGFloat roundProfit;
/** 机建费 */
@property (nonatomic, assign) CGFloat airportTax;
/** 燃油费 */
@property (nonatomic, assign) CGFloat fuelTax;
/** 是否儿童舱位 */
@property (nonatomic, assign) BOOL isChild;
/** 附加数据 */
@property (nonatomic, copy) NSString *extraData;
/** 标识 */
@property (nonatomic, assign)NSInteger optionset;
/** 数据更新时间 */
@property (nonatomic, assign)NSTimeInterval updated;
/** 数据过期时间 */
@property (nonatomic, assign)NSTimeInterval expire;
/** 票源 */
@property (nonatomic, assign)NSInteger sourceFrom;
/** 改签规则 */
@property (nonatomic, copy) NSString * alertedRule;
/** 退票规则 */
@property (nonatomic, copy) NSString * refundRule;
/** 其他规则说明 */
@property (nonatomic, copy) NSString * otherRule;
/** 是否支持电子发票 */
@property (nonatomic, assign) BOOL supportJourney;
/** 是否支持儿童 */
@property (nonatomic, assign) BOOL supportChild;
/** 是否支持婴儿 */
@property (nonatomic, assign) BOOL supportBaby;

@end


/*
 id":"",
 "flightId":"",
 "cabinType":"F",
 "cabinCode":"F",
 "cabinName":"头等舱",
 "stock":10,
 "discount":"9.7",
 "cabinTypePrice":5757,
 "singlePrice":0,
 "roundFullPrice":0,
 "profit":168,
 "roundPrice":0,
 "roundProfit":0,
 "airportTax":50,
 "fuelTax":0,
 "isChild":0,
 "extraData":"",
 "optionset":3,
 "updated":0,
 "expire":0,
 "sourceFrom":3,
 "alertedRule":"允许签转，如变更后承运人适用票价高于国航票价，需补齐差额后进行变更，若低于国航票价，差额不退。",
 "refundRule":"起飞（含）前免收退票费，起飞后需收取票面价10％的退票费（婴儿免收退票费）。",
 "otherRule":"",
 "supportJourney":1,
 "supportChild":1,
 "supportBaby":0
*/