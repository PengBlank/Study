//
//  HYFlightOrder.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

#import "HYPassengers.h"
#import "HYFlightRefundInfo.h"
#import "HYFlightAlertedInfo.h"
#import "HYRiseCabinInfo.h"
#import "HYFlightJourneyInfo.h"
#import "HYFlightOrderItem.h"
#import "HYFlightGuest.h"


@interface HYFlightOrder : JSONModel

//@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, copy) NSString *user_id;
//@property (nonatomic, copy) NSString *chinapay_tn;  //银联支付的流水号
//@property (nonatomic, copy) NSString *order_no;
//@property (nonatomic, copy) NSString *tel;
//@property (nonatomic, copy) NSString *ticket_no;
//@property (nonatomic, copy) NSString *org_airport;
//@property (nonatomic, copy) NSString *dst_airport;
//@property (nonatomic, copy) NSString *org_city_name;
//@property (nonatomic, copy) NSString *dst_city_name;
//@property (nonatomic, copy) NSString *org_airport_name;
//@property (nonatomic, copy) NSString *dst_airport_name;
//@property (nonatomic, copy) NSString *org_airport_terminal;
//@property (nonatomic, copy) NSString *dst_airport_terminal;
//@property (nonatomic, copy) NSString *flight_date;
//@property (nonatomic, copy) NSString *airline_name;
//@property (nonatomic, copy) NSString *flight_no;
//@property (nonatomic, copy) NSString *cabin;
//@property (nonatomic, copy) NSString *cabin_type;
//@property (nonatomic, assign) float passenger_count;
//@property (nonatomic, assign) float cabin_price;  //机票购买单价
//@property (nonatomic, assign) float cabin_fd_price;  //机票票面价格
//@property (nonatomic, assign) float airport_tax;
//@property (nonatomic, assign) float fuel_tax;
//@property (nonatomic, assign) float pay_total;
//@property (nonatomic, assign) BOOL is_allow_pnr;
//@property (nonatomic, copy) NSString *passenger_type;
//@property (nonatomic, copy) NSString *dep_time;
//@property (nonatomic, copy) NSString *arr_time;
//@property (nonatomic, assign) BOOL is_buy_insurance;

//@property (nonatomic, readonly, copy) NSString *statusDesc;
@property (nonatomic, assign) NSTimeInterval createTimestamp;
@property (nonatomic, readonly, copy) NSString *createTime;

//@property (nonatomic, strong) NSArray *passengers;


@property (nonatomic, copy) NSString *userName;  //用户名
@property (nonatomic, assign) NSInteger orderType;  //0为自身订单   =1为下属员工的订单

@property (nonatomic, assign) int source;  //1：携程  其他：特奢汇

@property (nonatomic, assign) BOOL isNeenJourney;   //行程单需要吗

//订单基本信息
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *orderShowStatus;
@property (nonatomic, copy) NSString *buyerId;
@property (nonatomic, copy) NSString *buyerNick;
@property (nonatomic, copy) NSString *buyerMobile;
@property (nonatomic, copy) NSString *stopTime;
@property (nonatomic, assign) CGFloat orderTbAmount;
@property (nonatomic, assign) CGFloat orderTotalAmount;
@property (nonatomic, assign) CGFloat orderPayAmount;
@property (nonatomic, assign) CGFloat orderCash;
@property (nonatomic, assign) CGFloat walletAmount;
@property (nonatomic, assign) BOOL walletStatus;
@property (nonatomic, copy) NSString *creationTime;
@property (nonatomic, assign) float points;

@property (nonatomic, strong) NSArray<HYFlightOrderItem> *orderItems;
@property (nonatomic, strong) NSArray<HYFlightGuest> *guests;

@property (nonatomic, strong) HYFlightRefundInfo *refundInfo;
@property (nonatomic, strong) HYFlightAlertedInfo *alteredInfo;
@property (nonatomic, strong) HYRiseCabinInfo *cabinInfo;
@property (nonatomic, strong) HYFlightJourneyInfo *journeyInfo;
@property (nonatomic, assign) BOOL hasJourney;
@property (nonatomic, assign) BOOL hasAlteredInfo;
@property (nonatomic, assign) BOOL hasRiseCabinInfo;

// 新增机票返现金额字段
@property (nonatomic, copy) NSString *returnAmount;
// 返现状态 0:待返现，1：已返现
// @property (nonatomic, assign) NSInteger *returnStatus;
// 返现状态显示名称
@property (nonatomic, copy) NSString *returnStatusName;
// @property (nonatomic, copy) NSString *statusDesc;

- (NSString *)statusDesc;

@end


/*
 id	INT	航班号
 order_no	STRING	航空公司二字码
 tel	STRING	联系人电话
 ticket_no	STRING	机票票号
 passengers	OBJECT	乘机人信息
 org_airport	STRING	出发城市三字码(详细到机场)
 dst_airport	STRING	到达城市三字码出发城市三字码(详细到机场)
 org_airport_name	STRING	出发城市名称
 dst_airport_name	STRING	到达城市名称
 org_airport_terminal	STRING	出发机场航站楼
 dst_airport_terminal	STRING	到达机场航站楼
 flight_date	STRING	起飞日期 yyyy-mm-dd
 airline_name	STRING	航空公司名称
 flight_no	STRING	航班号
 cabin	STRING	舱位代码
 cabin_type	STRING	舱位类型(F/C/Y)
 F:：头等舱
 C：商务舱
 Y：经济舱
 passenger_count	INT	乘机人数
 unit_points	INT	订单中单张机票用户能获得的现金券
 cabin_price	FLOAT	机票票面单价
 airport_tax	FLOAT	机场建设费
 fuel_tax	FLOAT	燃油费
 points	INT	订单能获得的总现金券
 pay_total	FLOAT	飞行时间，单位：分钟
 is_allow_pnr	INT	是否允许更换 PNR 出票
 0-  允许
 1-  不允许
 passenger_type	STRING	乘客类型
 A:  成人  C:  儿童
 dep_time	STRING	起飞时间 hh:mm
 arr_time	STRING	到达时间 hh:mm
 is_buy_insurance	INT	是否成功购买保险
 0： 否   1： 是
 status	INT	订单状态（详情参考附录）
 */