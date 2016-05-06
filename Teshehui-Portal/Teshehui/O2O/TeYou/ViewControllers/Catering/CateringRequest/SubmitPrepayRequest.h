//
//  SubmitPrepayRequest.h
//  Teshehui
//
//  Created by macmini5 on 16/3/3.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  会员充值提交 网络请求

#import "CQBaseRequest.h"

@interface SubmitPrepayRequest : CQBaseRequest
/*
 参数：userId（用户id），merId(商家id)，coupon（现金券），userName（用户名），cardNo（会员卡号），mobile（手机号），merchantName（商家名），amount（金额），productName（类型 桌球城pc端 Billiards 橙巨人端 Orange 充值支付 RechargePay 充值消费 RechargeCost）merchantLogo（商家logo
 
 充值二维码规则：
 snack&sid=670b14728ad9902aecba32e22fa4f6bd
 snack代表 快餐类型  sid代表商家ID
*/
@property (nonatomic, strong) NSString *UId;
@property (nonatomic, strong) NSString *merId;
@property (nonatomic, strong) NSString *coupon;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *cardNo;

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *merchantLogo;



@end
