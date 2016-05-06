//
//  HYPhoneChargeOrder.h
//  Teshehui
//
//  Created by 成才 向 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYPhoneChargeOrder : JSONModel

@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *payStatus;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *pointType;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userTelephone;
@property (nonatomic, copy) NSString *notPayAmount;
@property (nonatomic, copy) NSString *orderAmount;
@property (nonatomic, copy) NSString *rechargeType;
@property (nonatomic, copy) NSString *rechargeTelephone;
@property (nonatomic, copy) NSString *rechargeAmount;
@property (nonatomic, copy) NSString *cashCoupon;
@property (nonatomic, copy) NSString *orderTradeAmount;
@property (nonatomic, copy) NSString *costTradeAmount;
@property (nonatomic, copy) NSString *points;


@end
