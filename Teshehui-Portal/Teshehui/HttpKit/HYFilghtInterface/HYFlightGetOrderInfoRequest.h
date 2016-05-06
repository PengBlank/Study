//
//  HYFlightGetOrderInfoRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * d)	查询用户单个订单详细
 */
#import "CQBaseRequest.h"
#import "HYFlightGetOrderInfoResponse.h"

@interface HYFlightGetOrderInfoRequest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *user_id;  //搜索航班日期(时间戳)
@property (nonatomic, copy) NSString *orderCode;  //订单号

//可选字段
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, assign) NSInteger isEnterprise;  //企业账号查看企业员工因公消费.is_enterprise=1

@end
