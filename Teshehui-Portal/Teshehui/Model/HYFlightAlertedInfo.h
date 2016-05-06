//
//  HYFlightAlertedInfo.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * alerted_info(改签信息)
 */

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface HYFlightAlertedInfo : JSONModel
/*
@property (nonatomic, copy) NSString *alertID;
@property (nonatomic, copy) NSString *org_airport;
@property (nonatomic, copy) NSString *dst_airport;
@property (nonatomic, copy) NSString *flight_no;
@property (nonatomic, copy) NSString *flight_date;
@property (nonatomic, copy) NSString *passengers;
@property (nonatomic, copy) NSString *cabin_type;
@property (nonatomic, copy) NSString *cabin_name;
@property (nonatomic, copy) NSString *cabin_code;
@property (nonatomic, assign) float pay_total;
@property (nonatomic, assign) int points;
@property (nonatomic, assign) NSInteger status;*/
@property (nonatomic, readonly, copy) NSString *statusDesc;

@property (nonatomic, copy) NSString *alterId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *passengers;
@property (nonatomic, copy) NSString *flightNo;
@property (nonatomic, copy) NSString *cabinType;
@property (nonatomic, copy) NSString *cabinCode;
@property (nonatomic, copy) NSString *flightDate;
@property (nonatomic, assign) CGFloat orderCash;
@property (nonatomic, assign) CGFloat walletAmount;
@property (nonatomic, assign) BOOL walletStatus;
@property (nonatomic, assign) CGFloat payTotal;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) CGFloat sourceFee;
@property (nonatomic, copy) NSString *sourceOrderNo;
@property (nonatomic, copy) NSString *extraData;
@property (nonatomic, copy) NSString *finishTime;
@property (nonatomic, copy) NSString *creationTime;
@property (nonatomic, assign) int status;

@end


/*
 id	INT	改签ID
 org_airport	STRING	改签到出发城市三字码(详细到机场)
 dst_airport	STRING	改签到到达城市三字码出发城市三字码(详细到机场)
 flight_no	STRING	改签到航班号
 flight_date	STRING	改签到航班的起飞日期 yyyy-mm-dd
 passengers	STRING	改签的乘客名字（多个用”|”隔开）
 cabin_type	STRING	改签到的舱位类型
 cabin_code	STRING	改签到的舱位代码
 pay_total	FLOAT	改签价格（0为免费）
 status	INT	改签状态（详情参考附录）
 */