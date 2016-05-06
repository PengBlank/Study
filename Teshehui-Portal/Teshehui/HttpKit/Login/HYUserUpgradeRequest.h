//
//  HYUserUpgradeRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/18.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYUserUpgradeResponse.h"

@interface HYUserUpgradeRequest : CQBaseRequest

// 原来的参数
//@property (nonatomic, strong) NSString *userId;
//@property (nonatomic, strong) NSString *certificateType;
//@property (nonatomic, strong) NSString *certificateCode;
//@property (nonatomic, strong) NSString *realName;
//@property (nonatomic, strong) NSString *birthday;
//@property (nonatomic, strong) NSString *mobilephone;
//@property (nonatomic, strong) NSString *isBuyPolicy;
//@property (nonatomic, strong) NSString *policyType;
//@property (nonatomic, assign) NSInteger sex;

// 新的参数
@property(nonatomic, copy) NSString *orderType; //10 升级 20续费
@property(nonatomic, copy) NSString *policyType;    //0平安1人奢
@property(nonatomic, copy) NSString *isBuypolicy;   //是否购买保险
@property (nonatomic, copy) NSString *certificateCode;
@property (nonatomic, copy) NSString *certificateNumber;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, assign) NSInteger sex;    //服务器性别 1男0女
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *mobilephone;
/*
 private String token;
 private Long userId;
 private String userName;
 private Long price; //续费费用 会员卡费用 单位元 :100
 private String productSkuCode;//sku编码 产品编码 续费产品:CARD0000002，体验会员升级产品CARD0000003
 private String clientIP;
 private Integer orderType; //4升级会员卡 ，5续费续保
 private String policyType;//保险类型 1 阳光 2人寿
 private Boolean hasPolicy;//是否买保险  1 0
 */

@end