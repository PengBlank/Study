//
//  HYFlowerOrderListInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYFlowerOrderListInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, copy) NSString *completed;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *invoice_address;
@property (nonatomic, copy) NSString *invoice_company;
@property (nonatomic, copy) NSString *invoice_content;
@property (nonatomic, copy) NSString *invoice_district_id;
@property (nonatomic, copy) NSString *invoice_name;
@property (nonatomic, copy) NSString *invoice_phone;
@property (nonatomic, copy) NSString *invoice_type;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *pay_total;
@property (nonatomic, copy) NSString *total_amount;
@property (nonatomic, copy) NSString *unit_price;
@property (nonatomic, copy) NSString *updated;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *product_name;
@property (nonatomic, copy) NSString *product_desc;
@property (nonatomic, copy) NSString *product_img;
@property (nonatomic, copy) NSString *product_pack;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *delivery_time;
@property (nonatomic, copy) NSString *receiver_name;  //地址
@property (nonatomic, copy) NSString *receiver_address;
@property (nonatomic, copy) NSString *small_product_img;
@property (nonatomic, copy) NSString *middle_product_img;
@property (nonatomic, copy) NSString *userMessage;  //祝福语
@property (nonatomic, copy) NSString *address;  //地址

@property (nonatomic, copy) NSString *user_name;  //用户名
@property (nonatomic, assign) NSInteger order_type;  //0为自身订单   =1为下属员工的订单

@property (nonatomic, assign, readonly) CGFloat userMessageHeight;
@property (nonatomic, assign, readonly) CGFloat addressHeight;
@property (nonatomic, assign, readonly) CGFloat contentHeight;  //内容高度

@property (nonatomic, strong, readonly) NSString *statusDesc;

@end
/*
 "id": 105,
 "user_id": 102,
 "order_no": "BCNS02041725",
 "total_amount": 333,
 "pay_total": 333,
 "order_status": 1,
 "points": 333,
 "invoice_type": 0,
 "invoice_company": "",
 "invoice_content": "",
 "invoice_name": "",
 "invoice_phone": "",
 "invoice_address": "",
 "cancel_at": 0,
 "completed": 0,
 "quantity": "1",
 "unit_price": "333.00",
 "product_name": "阳光心情",
 "product_desc": "想着，我们曾一起跨过海边；想着，我们曾一起晒过太阳；想着，我们曾一起坐着小火车；想着，我们曾手牵手走过曾经。此刻，我的心情一如阳光般温暖！",
 "product_img": "http://image.wodinghua.com/\\behindImg\\goods\\2013\\08\\16\\FLS0034\\FLS0034.jpg",
 "product_pack": "绿色瓦楞纸圆形包装；搭配绿色蝴蝶结",
 "province": "?",
 "city": "?",
 "district": "????????o",
 "receiver_address": "?????3?",
 "zip_code": 518000,
 "receiver_name": "?????o",
 "receiver_phone": "18118762005",
 "updated": "2014-03-12 16:02:04",
 "created": "2014-03-12 16:02:04",
 "small_product_img": "http://flower.teshehui.com/phpThumb/phpThumb.php?src=http://image.wodinghua.com//behindImg/goods/2013/08/16/FLS0034/FLS0034.jpg&w=120&hash=54cdbf6bccedbaaba549c630689c04b2",
 "middle_product_img": "http://flower.teshehui.com/phpThumb/phpThumb.php?src=http://image.wodinghua.com//behindImg/goods/2013/08/16/FLS0034/FLS0034.jpg&w=240&hash=19daa67d5825f726850fc3f027817fec"
 */