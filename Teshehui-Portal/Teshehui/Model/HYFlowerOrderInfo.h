//
//  HYFlowerOrderInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYFlowerOrderInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString* orderID;
@property (nonatomic, copy) NSString* order_id;
@property (nonatomic, copy) NSString* amount;
@property (nonatomic, copy) NSString* buyer_name;
@property (nonatomic, copy) NSString* buyer_phone;
@property (nonatomic, copy) NSString* cancel_at;
@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* city_id;
@property (nonatomic, copy) NSString* completed;
@property (nonatomic, copy) NSString* created;
@property (nonatomic, copy) NSString* delivery_time;
@property (nonatomic, copy) NSString* district;
@property (nonatomic, copy) NSString* district_id;
@property (nonatomic, copy) NSString* invoice_address;
@property (nonatomic, copy) NSString* invoice_company;
@property (nonatomic, copy) NSString* invoice_content;
@property (nonatomic, copy) NSString* invoice_district_id;
@property (nonatomic, copy) NSString* invoice_name;
@property (nonatomic, copy) NSString* invoice_phone;
@property (nonatomic, copy) NSString* invoice_type;
@property (nonatomic, copy) NSString* order_item_no;
@property (nonatomic, copy) NSString* order_no;
@property (nonatomic, assign) NSInteger order_status;
@property (nonatomic, copy) NSString* pay_total;
@property (nonatomic, copy) NSString* product_code;
@property (nonatomic, copy) NSString* product_name;
@property (nonatomic, copy) NSString* province;
@property (nonatomic, copy) NSString* product_id;
@property (nonatomic, copy) NSString* province_id;
@property (nonatomic, copy) NSString* quantity;
@property (nonatomic, copy) NSString* receiver_address;
@property (nonatomic, copy) NSString* receiver_name;
@property (nonatomic, copy) NSString* receiver_phone;
@property (nonatomic, copy) NSString* status_id;
@property (nonatomic, copy) NSString* status_name;
@property (nonatomic, copy) NSString* total_amount;
@property (nonatomic, copy) NSString* unit_price;
@property (nonatomic, copy) NSString* updated;
@property (nonatomic, copy) NSString* user_id;
@property (nonatomic, copy) NSString* zip_code;
@property (nonatomic, copy) NSString* points;

@property (nonatomic, copy) NSString *user_name;  //用户名
@property (nonatomic, assign) NSInteger order_type;  //0为自身订单   =1为下属员工的订单

@end

/*
 id
 INT
 订单ID
 order_id
 INT
 订单ID
 amount
 FLOAT
 订单商品的总价
 buyer_name
 STRING
 购买人名称
 buyer_phone
 STRING
 购买人联系方式
 cancel_at
 INT
 订单取消时间（如果订单状态为取消）
 city
 STRING
 收货地址市名
 city_id
 INT
 收货地址市区域ID（第二级区域）
 completed
 INT
 订单完成时间（如果订单状态为完成）
 created
 DATETIME
 订单创建时间
 delivery_time
 DATE
 配送时间
 district
 STRING
 收货地址区域名
 district_id
 INT
 收货地址区域ID（最子层区域）
 invoice_address
 STRING
 收票地址
 invoice_company
 STRING
 发票公司
 invoice_content
 STRING
 发票内容
 invoice_district_id
 INT
 收票所在区域编号（最子层区域）
 invoice_name
 STRING
 收票人姓名
 invoice_phone
 STRING
 收票人联系方式
 invoice_type
 INT
 发票类型 0个人 1公司
 order_item_no
 STRING
 订单商品号（只有付款后才有）
 order_no
 STRING
 订单号
 order_status
 INT
 订单状态
 pay_total
 FLOAT
 订单应付总金额
 product_code
 STRING
 订单商品编号
 product_id
 INT
 订单商品ID
 product_name
 STRING
 订单商品名称
 province
 STRING
 收货地址省名
 province_id
 INT
 收货地址省区域ID（最上级区域）
 quantity
 INT
 购买数量
 receiver_address
 STRING
 收货人地址详细
 receiver_name
 STRING
 收货人姓名
 receiver_phone
 STRING
 收票人联系方式
 status_id
 INT
 订单商品状态
 status_name
 STRING
 订单商品状态名称
 total_amount
 FLOAT
 订单总金额
 unit_price
 FLOAT
 订单商品单价
 updated
 DATETIME
 订单最后更新时间
 user_id
 INT
 第三方用户ID
 zip_code
 INT
 收货地址邮编
 points
 INT
 订单积分
 
 */