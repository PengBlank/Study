//
//  BilliardsCreateOrderRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface BilliardsCreateOrderRequest : CQBaseRequest


@property (nonatomic,strong) NSString *merId; //商家ID
@property (nonatomic,strong) NSString *uName; //用户名
@property (nonatomic,strong) NSString *uId; //特奢汇用户ID

@property (nonatomic,strong) NSString *cardNo; //会员卡号
@property (nonatomic,strong) NSString *mobile; //会员手机号

@property (nonatomic,strong) NSString *orId; //桌球城订单号

@property (nonatomic,assign) NSInteger isPayCoupon; //是否支付现金券


@end
