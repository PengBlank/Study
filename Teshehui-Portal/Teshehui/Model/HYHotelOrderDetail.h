//
//  HYHotelOrderDetail.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderBase.h"
#import "HYHotelInvoiceModel.h"
#import "HYHotelOrderItemPO.h"
#import "HYHotelGuestPO.h"
#import "HYDeliveryAddressPO.h"

typedef enum _HotelPayType{
    Online_Pay = 1,
    Phone_Pay,
    Offline_Pay
}HotelPayType;

@interface HYHotelOrderDetail : HYHotelOrderBase

//Java后台新字段
@property (nonatomic, copy) NSString *startTimeSpan;
@property (nonatomic, copy) NSString *endTimeSpan;
@property (nonatomic, copy) NSString *latestArrivalTime;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactMobile;
@property (nonatomic, strong) NSArray<HYHotelGuestPO> *guestPOList;
@property (nonatomic, strong) NSArray<HYHotelOrderItemPO> *orderItemPOList;
@property (nonatomic, strong) NSArray<HYDeliveryAddressPO> *deliveryAddressPOList;
@property (nonatomic, copy) NSString *businessType;

@property (nonatomic, copy) NSString *orderPayAmount;
@property (nonatomic, copy) NSString *orderTbAmount;
@property (nonatomic, copy) NSString *invoiceTitle;
@property (nonatomic, copy) NSString *creationTime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *deliveryFee;


- (BOOL)isPrePay;
- (NSString *)payTypeDesc;


//便捷方法
- (NSString *)hotelName;
- (NSString *)personName;
- (NSString *)startTimeSpanDate;
- (NSString *)endTimeSpanDate;

@end

//{
//    "data": {
//        "startTimeSpan": "2015-05-27 00:00:00",
//        "endTimeSpan": "2015-05-28 00:00:00",
//        "latestArrivalTime": "2015-05-27 18:00:00",
//        "contactName": "韩韩韩",
//        "contactMobile": "18888888888",
//        "guestPOList": [
//                        {
//                            "name": "韩韩韩",
//                            "certificateCode": 0,
//                            "gender": 0
//                        }
//                        ],
//        "orderItemPOList": [
//                            {
//                                "cityId": 2003,
//                                "cityName": "深圳",
//                                "roomName": "标准双人房",
//                                "telephone": "0755-88352090",
//                                "address": "福田区福华路135号",
//                                "lon": "",
//                                "lat": "",
//                                "gLon": "",
//                                "gLat": "",
//                                "gdLon": "",
//                                "gdLat": "",
//                                "ratePlanCategory": "14",
//                                "guaranteeType": "",
//                                "businessType": "03",
//                                "productId": 215,
//                                "productCode": "22003149",
//                                "productName": "深圳福泉宾馆",
//                                "productSKUId": 1,
//                                "points": 148,
//                                "quantity": 1
//                            }
//                            ],
//        "orderId": 1234,
//        "orderCode": "HCE5S2317510516",
//        "businessType": "03",
//        "status": 0,
//        "orderShowStatus": "待处理",
//        "buyerId": 4154,
//        "buyerNick": "韩韩韩",
//        "orderTotalAmount": 148,
//        "orderPayAmount": 148,
//        "invoiceTitle": "",
//        "creationTime": "2015-05-27 15:23:17",
//        "orderType": 0,
//        "remark": "",
//        "deliveryAddressPOList": [
//                                  {
//                                      "type": 2,
//                                      "realName": "",
//                                      "mobile": "",
//                                      "postCode": "",
//                                      "address": "",
//                                      "remark": ""
//                                  }
//                                  ]
//    },
//    "status": 200,
//    "message": null,
//    "code": null,
//    "suggestMsg": null
//}

/*
 @property (nonatomic, copy) NSString *hOrderID;
 @property (nonatomic, copy) NSString *hOrder_no;
 @property (nonatomic, copy) NSString *user_id;
 @property (nonatomic, copy) NSString *retry_time;
 @property (nonatomic, copy) NSString *updated;
 @property (nonatomic, copy) NSString *created;
 @property (nonatomic, assign) HotelOrderStatus status;
 @property (nonatomic, assign) int contract;
*/

/*
 id	INT	订单ID
 order_no	STRING	订单NO.
 amount_before_tax	STRING	订单总价
 points	INT	积分/现金券
 status	INT	订单状态
 0 待处理 - 本地
 1 待处理 - 携程
 2 处理中
 4 已确认
 8 已取消
 16 已成功
 -1 下单失败
 created	INT	生成订单的时间截
 pay_type	STRING	C为到店付款，P预付款
 目前只有支持C到店付款
 guarantee_type	STRING	默认值CreditCard-信用卡，目前只有信用卡，需要根据担保金额确定是否担保，如果金额大于0，则是信用卡担保
 amount_percent	STRING	担保金额
 city_id	STRING	城市ID
 city_name	STRING	城市名称
 hotel_id	STRING	酒店ID
 hotel_name	STRING	酒店名称
 room_id	STRING	房间ID
 room_name	STRING	房间名称
 number_of_units	STRING	房间数量
 start_time_span	STRING	入住时间，时间截
 end_time_span	STRING	离店时间，时间截
 late_arrival_time	STRING	最晚到店时间
 address	STRING	酒店地址
 LON	STRING	经度(图吧)
 LAT	STRING	纬度(图吧)
 GLON	STRING	经度(Google)
 GLAT	STRING	纬度(Google)
 GDLON	STRING	经度(高德)
 GDLAT	STRING	纬度(高德)
 telephone	STRING	酒店电话
 person_name	STRING	入住人姓名
 contact_person_surname	STRING	联系人姓名
 phone_number	STRING	联系人电话
 special_request	STRING	特殊要求
*/

