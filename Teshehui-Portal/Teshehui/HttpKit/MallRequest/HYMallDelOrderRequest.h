//
//  HYMallDelOrderRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-6-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *商城删除订单
 */

#import "CQBaseRequest.h"
#import "HYMallDelOrderResponse.h"

@interface HYMallDelOrderRequest : CQBaseRequest

//@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_code;

@end
