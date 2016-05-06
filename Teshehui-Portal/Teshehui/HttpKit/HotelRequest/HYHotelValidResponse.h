//
//  HYHotelValidResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYHotelGuaranteePayment.h"

@interface HYHotelValidResponse : CQBaseResponse

@property (nonatomic, assign) double totalAmount;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) NSInteger productTypeCode;     /** 酒店房型产品类型编码（0未知，1普通，2担保，3预付） */
@property (nonatomic, assign) CGFloat guaranteeAmount;
@property (nonatomic, copy) NSString *cancelStartTime;
@property (nonatomic, copy) NSString *cancelEndTime;
@property (nonatomic, copy) NSString *guaranteeCurrencyCode;
@property (nonatomic, copy) NSString *guaranteeDescription;
@property (nonatomic, copy) NSString *cancelAmount;
@property (nonatomic, copy) NSString *cancelCurrencyCode;

/*
 totalAmount	Double	订单总金额
 productTypeCode	enum	产品类型，未知：0，现付1，担保2，预付3
 guaranteeAmount	Double	担保金额
 cancelEndTime	String	最晚取消时间（格式YYYY-MM-dd HH:mm:ss)
 cancelStartTime	String	最早取消时间（格式YYYY-MM-dd HH:mm:ss)（可能没有）
 guaranteeCurrencyCode	String	担保金额货币单位（可能没有）
 guaranteeDescription	String	担保描述（可能没有）
 cancelAmount	String	取消金额（可能没有）
 cancelCurrencyCode	String	取消金额货币单位（可能没有）
 */

@end
