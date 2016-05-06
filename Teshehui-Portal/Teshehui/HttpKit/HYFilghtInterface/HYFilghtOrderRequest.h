//
//  HYFilghtOrderRequest.h
//  ComeHere
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 机票订单
 */

#import "CQBaseRequest.h"

@interface HYFilghtOrderRequest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *user_id;  //搜索航班日期(时间戳)
@property (nonatomic, copy) NSString *passengers;  //出发城市三字码
@property (nonatomic, copy) NSString *passenger_id_cards;  //到达城市三字码
@property (nonatomic, copy) NSString *cabin_code;  //舱位号
@property (nonatomic, copy) NSString *flight_no;  //航班号
@property (nonatomic, copy) NSString *org_airport;  //出发机场三字码
@property (nonatomic, copy) NSString *dst_airport;  //到达机场三字码
@property (nonatomic, copy) NSString *date;  //出发日期  时间戳

//可选字段
@property (nonatomic, copy) NSString *jounery;  //是否打印行程单  是否打印行程单，0-不打印 1-打印  默认 0   "1|0|0"

@end
