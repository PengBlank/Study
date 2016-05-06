//
//  HYHotelOrderRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店生成订单
 */

#import "CQBaseRequest.h"
#import "HYHotelInvoiceModel.h"

@interface HYHotelOrderRequest : CQBaseRequest

//必须参数
@property (nonatomic, assign) CGFloat itemTotalAmount;
@property (nonatomic, copy) NSString *discountAmount;
@property (nonatomic, assign) CGFloat orderTotalAmount;
@property (nonatomic, copy) NSString *discountDescription;
@property (nonatomic, strong) NSArray *orderItemList;
@property (nonatomic, copy) NSString *productSKUCode;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger quantity;  //INT	预订房间的数量
@property (nonatomic, copy) NSString *startTimeSpan; //入住时间
@property (nonatomic, copy) NSString *endTimeSpan;  //离店时间
@property (nonatomic, copy) NSString *latestArrivalTime; //最早入店时间
@property (nonatomic, copy) NSString *contactName; //联系人姓名
@property (nonatomic, copy) NSString *contactPhone; //联系人电话
@property (nonatomic, copy) NSString *contactEmail; //联系人邮件
@property (nonatomic, strong) NSArray *guestPOList; //旅客信息


//担保
@property (nonatomic, copy) NSString *creditCardType;
@property (nonatomic, copy) NSString *creditCardNumber;
@property (nonatomic, copy) NSString *creditCardSeriesCode;
@property (nonatomic, copy) NSString *creditCardEffectiveDate;
@property (nonatomic, copy) NSString *creditCardHolderName;
@property (nonatomic, copy) NSString *creditCardHolderIDCardNumber;
@property (nonatomic, copy) NSString *creditCardHolderMobile;

@property (nonatomic, assign) BOOL isNeedInvoice; //是否需要发票
@property (nonatomic, copy) NSString *remark;//特殊要求
@property (nonatomic, copy) NSString *isEnterprise;

@property (nonatomic, strong) HYHotelInvoiceModel *invoiceModel;

@end
