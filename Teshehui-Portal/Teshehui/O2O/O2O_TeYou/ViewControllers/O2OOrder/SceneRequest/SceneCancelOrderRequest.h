//
//  SceneCancelOrderRequest.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/13.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  场景消费 取消订单

#import "CQBaseRequest.h"

@interface SceneCancelOrderRequest : CQBaseRequest

/** o2o订单号*/
@property (nonatomic, copy) NSString *o2oOrderNo;
/** 套餐名*/
@property (nonatomic, copy) NSString *packageName;

@end
