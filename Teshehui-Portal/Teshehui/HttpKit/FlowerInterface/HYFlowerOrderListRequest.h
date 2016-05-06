//
//  HYFlowerOrderListRequest.h
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYFlowerOrderListRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNo;

//可选参数
/*
 订单列表类型 取值: 0：全部；1：待付款；2：待发货; 3:待收货；4：待评价；5：退换货；(type)
 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *startTime;  //下单时间起始，时间截格式
@property (nonatomic, copy) NSString *endTime;  //下单时间结束，时间截格式

@property (nonatomic, assign) BOOL isEnterprise;

@end
