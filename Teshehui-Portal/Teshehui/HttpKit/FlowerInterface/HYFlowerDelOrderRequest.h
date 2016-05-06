//
//  HYFlowerDelOrderRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-6-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 鲜花订单删除
 */

#import "CQBaseRequest.h"
#import "HYFlowerDelOrderResponse.h"

@interface HYFlowerDelOrderRequest : CQBaseRequest

@property(nonatomic, copy) NSString* orderNo;

@end
