//
//  HYOnlineBuyCardResp.h
//  Teshehui
//
//  Created by HYZB on 14/11/4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYOnlineBuyCardResp : CQBaseResponse

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *order_name;
@property (nonatomic, copy) NSString *pay_total;

@end


/*
 order_id	String	订单ID
 order_no	String	订单编号
 order_name	String	订单名称
 pay_total	String	付款金额
*/