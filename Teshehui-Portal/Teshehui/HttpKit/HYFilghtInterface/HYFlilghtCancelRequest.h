//
//  HYFlilghtCancelRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * i)	取消订单
 */
#import "CQBaseRequest.h"
#import "HYFlilghtCancelResponse.h"

@interface HYFlilghtCancelRequest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *user_id;  //商城用户ID
@property (nonatomic, copy) NSString *orderCode;  //订单号

//可选字段


@end
