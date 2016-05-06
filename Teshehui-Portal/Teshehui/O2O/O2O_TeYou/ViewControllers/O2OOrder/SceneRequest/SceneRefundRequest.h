//
//  SceneRefundRequest.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/13.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  场景消费 退款申请请求

#import "CQBaseRequest.h"

@interface SceneRefundRequest : CQBaseRequest

/** o2o订单号 */
@property (nonatomic, copy) NSString *o2oOrderNo;
/** 套餐名*/
@property (nonatomic, copy) NSString *packageName;
/** 原因*/
@property (nonatomic, copy) NSString *reason;

@end
