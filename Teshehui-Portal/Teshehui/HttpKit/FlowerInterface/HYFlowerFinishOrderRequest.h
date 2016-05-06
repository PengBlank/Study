//
//  HYFlowerFinishOrderRequest.h
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYFlowerFinishOrderRequest : CQBaseRequest

@property (nonatomic, copy) NSString *itemTotalAmount;
@property (nonatomic, copy) NSString *discountAmount;
@property (nonatomic, copy) NSString *orderTotalAmount;
@property (nonatomic, copy) NSString *discountDescription;
@property (nonatomic, copy) NSString *isNeedInvoice;
@property (nonatomic, copy) NSString *invoiceType;
@property (nonatomic, copy) NSString *invoiceTitle;
/*
 *[{"productSKUCode":"256","quantity":1,"price":100,"bless":"来吧测试鲜花下单"}]
 */
@property (nonatomic, copy) NSString *productSKUCode;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *bless;

@property (nonatomic, copy) NSString *deliveryTime;
@property (nonatomic, assign) BOOL isAnonymous;  //是否匿名	0:否    1：是
@property (nonatomic, copy) NSString *invoicePhone;
@property (nonatomic, copy) NSString *invoiceReasonId;
@property (nonatomic, copy) NSString *invoiceAddress;

@property (nonatomic, copy) NSString *isEnterprise;  //归属哪个企业用户

//地址
@property (nonatomic, copy) NSString *presentName;
@property (nonatomic, copy) NSString *presentPhone;
@property (nonatomic, copy) NSString *receiverName;
@property (nonatomic, copy) NSString *receiverPhone;
@property (nonatomic, copy) NSString *receiverAddress;
@property (nonatomic, copy) NSString *receiverZipCode;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *regionId;
@property (nonatomic, copy) NSString *regionName;

@end


