//
//  HYHotelDelOrderRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-6-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *删除酒店订单
 */

#import "CQBaseRequest.h"
#import "HYHotelDelOrderResponse.h"

@interface HYHotelDelOrderRequest : CQBaseRequest

@property (nonatomic, copy) NSString *hotel_id;  //酒店ID
@property (nonatomic, copy) NSString *order_id;
//Java新字段
@property (nonatomic, copy) NSString *orderId;

@end
