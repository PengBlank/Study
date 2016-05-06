//
//  HYCheckChildTicketReqeust.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 查询是否有儿童票
 */

#import "CQBaseRequest.h"
#import "HYCheckChildTicketResponse.h"

@interface HYCheckChildTicketReqeust : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *flight_date;  //搜索航班日期(时间戳)
@property (nonatomic, copy) NSString *org_city;  //出发城市三字码
@property (nonatomic, copy) NSString *dst_city;  //到达城市三字码
@property (nonatomic, copy) NSString *cabin_code;
@property (nonatomic, copy) NSString *flight_no;
@property (nonatomic, copy) NSString *pass_type; //乘客类型  默认儿童 CH
@property (nonatomic, assign) int source;
//可选字

@end
