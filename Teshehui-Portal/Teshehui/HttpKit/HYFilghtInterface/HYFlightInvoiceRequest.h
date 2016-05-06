//
//  HYFlightInvoiceRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * h)	订单行程单申请
 */

#import "CQBaseRequest.h"
#import "HYFlightInvoiceResponse.h"

@interface HYFlightInvoiceRequest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *user_id;  //
@property (nonatomic, copy) NSString *order_no;  //订单号
@property (nonatomic, copy) NSString *passengers;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *zip_code;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *address;

//可选字段

@end


/*
 user_id	INT	商城用户ID
 order_no	STRING	订单号
 passengers	STRING	需要打印行程单的乘客名字，多个用”|”隔开
 contact	STRING	联系人
 tel	STRING	联系人电话
 zip_code	STRING	邮政编码
 province	STRING	省份
 city	STRING	邮寄城市
 address	STRING	详细地址
*/