//
//  HYFlightOrderListRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  查询用户订单列表
 */

#import "CQBaseRequest.h"
#import "HYFlightOrderListResponse.h"

@interface HYFlightOrderListRequest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *user_id;  //搜索航班日期(时间戳)

//可选字段
@property (nonatomic, copy) NSString *employeeId;  //员工id
@property (nonatomic, copy) NSString *start_date;  //模糊搜索订单号
@property (nonatomic, copy) NSString *end_date;  //订单创建时间起（时间戳）
@property (nonatomic, copy) NSString *order_status;  //订单创建时间止（时间戳)
@property (nonatomic, assign) NSInteger page;  //页码
@property (nonatomic, assign) NSInteger page_size;  //每页大小
@property (nonatomic, assign) NSInteger is_enterprise;  //企业账号查看企业员工因公消费.is_enterprise=1
@property (nonatomic, copy) NSString *order_code;

@end
