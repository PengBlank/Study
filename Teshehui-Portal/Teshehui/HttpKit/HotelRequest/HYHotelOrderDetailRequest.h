//
//  HYHotelOrderDetailRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店订单详情的接口
 */

#import "CQBaseRequest.h"
#import "HYHotelOrderDetailResponse.h"

@interface HYHotelOrderDetailRequest : CQBaseRequest


//必须参数
@property (nonatomic, copy) NSString *orderId;  //订单ID

//可选参数
@property (nonatomic, copy) NSString *is_enterprise;  //如果是企业账号查询其员工的订单详情则需要使用该参数
@property (nonatomic, copy) NSString *employeeId;

@end
