//
//  HYAddRechargeOrderRequest.h
//  Teshehui
//
//  Created by Kris on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

/*
 Long orderAmount;  //订单金额
 Integer productCode;//购买商品的编号
 private Long     userId; //登录用户的ID
 private String  rechargeTelephone;//充值号码
 private Long    rechargeAmount;    //充值面额
 private Integer  rechargeType;    //充值类型    2：话费   5：流量
 */

@interface HYAddRechargeOrderRequest : CQBaseRequest

@property (nonatomic, copy) NSString *orderAmount;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *rechargeTelephone;
@property (nonatomic, copy) NSString *rechargeAmount;
@property (nonatomic, copy) NSString *rechargeType;

@end
