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
@property (nonatomic, strong) NSString *UId;            // 用户id
@property (nonatomic, strong) NSString *merId;          // 商家id
@property (nonatomic, strong) NSString *coupon;         // 现金券
@property (nonatomic, strong) NSString *userName;       // 用户名
@property (nonatomic, strong) NSString *cardNo;         // 会员卡号

@property (nonatomic, strong) NSString *mobile;         // 手机号
@property (nonatomic, strong) NSString *merchantName;   // 商家名
@property (nonatomic, strong) NSString *amount;         // 金额
@property (nonatomic, strong) NSString *productName;    // 产品名 默认值TSHAPP
@property (nonatomic, strong) NSString *merchantLogo;   // 商家logo

@property (nonatomic, strong) NSString *merchantType;   // 商家类型 桌球类型：Billiard，默认""

//@property (nonatomic, strong) NSString *firstAreaId;    // 商家所属一级区域id 默认0
//@property (nonatomic, strong) NSString *secondAreaId;   // 商家所属二级区域id 默认0
//@property (nonatomic, strong) NSString *thirdAreaId;    // 商家所属三级区域id 默认0
//@property (nonatomic, strong) NSString *fourthAreaId;   // 商家所属四级区域id 默认0

@end
