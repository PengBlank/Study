//
//  HYFlightJourneyInfo.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface HYFlightJourneyInfo : JSONModel

//@property (nonatomic, copy) NSString *journeyID;
//@property (nonatomic, copy) NSString *passengers;
//@property (nonatomic, copy) NSString *contact;
//@property (nonatomic, copy) NSString *tel;
//@property (nonatomic, copy) NSString *zip_code;
//@property (nonatomic, copy) NSString *province;
//@property (nonatomic, copy) NSString *city;
//@property (nonatomic, copy) NSString *address;
//@property (nonatomic, copy) NSString *item_no;
//@property (nonatomic, assign) CGFloat pay_total;
//@property (nonatomic, assign) CGFloat point;
//@property (nonatomic, copy) NSString *shipment;
//@property (nonatomic, copy) NSString *express_no;
//@property (nonatomic, assign) NSInteger status;
@property (nonatomic, readonly, copy) NSString *statusDesc;

@property (nonatomic, copy) NSString *journeyId;
@property (nonatomic, copy) NSString *itemNo;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *passengers;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *zipCode;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CGFloat payTotal;
@property (nonatomic, assign) CGFloat orderCash;
@property (nonatomic, assign) CGFloat walletAmount;
@property (nonatomic, assign) BOOL walletStatus;

@property (nonatomic, copy) NSString *shipment;
@property (nonatomic, copy) NSString *expressNo;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *creationTime;

@end


/*
 id	INT	行程单ID
 passengers	STRING	乘客名字（多个用”|”隔开）
 contact	STRING	行程单收件人
 tel	STRING	收件联系电话
 zip_code	STRING	收件邮编
 province	STRING	收件省名
 city	STRING	收件城市名
 address	STRING	收件详细地址
 item_no	STRING	行程单编号
 pay_total	FLOAT	应付总金额
 shipment	STRING	寄送快递
 express_no	STRING	快递单号
 status	INT	行程单状态（详情参考附录）
 */