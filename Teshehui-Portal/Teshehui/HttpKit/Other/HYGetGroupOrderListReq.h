//
//  HYGetGroupOrderListReq.h
//  Teshehui
//
//  Created by HYZB on 2014/12/17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYGroupOrderInfo.h"

@interface HYGetGroupOrderListReq : CQBaseRequest

//必须字段
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
//可选字段
@property (nonatomic, copy) NSString *thirdOrderId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *buyerId;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *orderStatus;  
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;


@end


/*
 thirdOrderId	STRING	第三方订单ID
 buyerId	STRING	用户ID
 orderType	STRING	订单类型：优惠券coupon，物流单delivery，二维码voucher
 orderStatus	STRING	订单状态：已付款=P、已消费=C、已退款=R、已下单=O
 startTime	STRING	开始时间，格式：yyyy-MM-dd
 startTime	STRING	结束时间，格式：yyyy-MM-dd(与开始时间参数同时出现)
 page	int	当前页数（默认为1）
 pageSize	int	每页显示记录数（默认为20）
*/

@interface HYGetGroupOrderListResq : CQBaseResponse

@property (nonatomic, strong) NSArray *orderList;

@end