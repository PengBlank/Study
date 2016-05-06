//
//  HYFlowerOrderListInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"
#import "HYFlowerOrderItem.h"
#import "HYOrderAddress.h"

@interface HYFlowerOrderSummary : NSObject

@property (nonatomic,strong) NSString *presentName;
@property (nonatomic,strong) NSString *presentPhone;

@property (nonatomic,strong) NSString *buyerNick;
@property (nonatomic,strong) NSString *invoiceType;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *updatedTime;
@property (nonatomic,strong) NSArray *orderItemPOList;
@property (nonatomic,strong) NSString *buyerMobile;
@property (nonatomic,strong) NSString *orderTotalAmount;
@property (nonatomic,strong) NSString *creationTime;
@property (nonatomic,strong) NSString *orderTbAmount;
@property (nonatomic,strong) NSString *orderShowStatus;
@property (nonatomic,strong) NSString *orderCode;
@property (nonatomic,strong) NSString *orderPayAmount;

@property (nonatomic, copy) NSString *orderCash;
@property (nonatomic, copy) NSString *walletAmount;
@property (nonatomic, assign) BOOL walletStatus;

@property (nonatomic,strong) NSString *buyerId;
@property (nonatomic,strong) NSString *invoiceTitle;
@property (nonatomic,strong) NSString *invoiceCompany;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *isEnterprise;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *shippingTime;
@property (nonatomic,strong) NSString *deliveryTime;
@property (nonatomic, strong) NSString *orderType;

@property (nonatomic, strong) NSArray *addressList;
@property (nonatomic, strong, readonly) HYOrderAddress *address;
@property (nonatomic, strong, readonly) HYOrderAddress *invoiceAddress;

@property (nonatomic, assign, readonly) CGFloat userMessageHeight;
@property (nonatomic, assign, readonly) CGFloat addressHeight;
@property (nonatomic, assign, readonly) CGFloat contentHeight;

-(id)initWithJson:(NSDictionary *)json;

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