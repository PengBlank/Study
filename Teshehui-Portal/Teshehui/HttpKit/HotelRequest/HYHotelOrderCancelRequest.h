//
//  HYHotelOrderCancelRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYHotelOrderCancelRequest : CQBaseRequest

//必须参数
@property (nonatomic, copy) NSString *order_id;  //INT 订单ID


//可选参数
@property (nonatomic, copy) NSString *cancel_reason;  //INT	取消原因代码 501	行程改变 502	无法满足需求 503	酒店价格倒挂 504	其它途径预订 505	价格不准确 506	重复预订 507	入住登记不详细 508	其他
@property (nonatomic, copy) NSString *reason_content;  //STRING	取消原因内容
//Java新字段
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *reasonCode;
@property (nonatomic, copy) NSString *reasonContent;
@end
