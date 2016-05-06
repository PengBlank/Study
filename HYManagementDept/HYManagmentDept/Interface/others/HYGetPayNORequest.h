//
//  HYGetPayNORequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 获取支付的银行流水号
 */
#import "HYBaseRequestParam.h"
#import "HYGetPayNOResponse.h"


@interface HYGetPayNORequest : HYBaseRequestParam

//必须字段
@property (nonatomic, copy) NSString *order_id;  //订单id
@property (nonatomic, copy) NSString *payment;  //支付方式

@property (nonatomic, assign) ProductPayType type;


@end
