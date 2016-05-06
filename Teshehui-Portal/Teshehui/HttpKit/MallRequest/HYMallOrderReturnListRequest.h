//
//  HYMallOrderReturnListRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  查询退换货订单列表
 */
#import "CQBaseRequest.h"
#import "HYMallOrderReturnListResponse.h"

@interface HYMallOrderReturnListRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger num_per_page;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger refund_type;    //1退货, 2闪电退, 3换货

@end
