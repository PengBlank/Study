//
//  HYContinueInsuranceRequest.h
//  Teshehui
//
//  Created by HYZB on 15/3/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYContinueInsuranceRequest : CQBaseRequest

@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *productSkuCode;
@property(nonatomic,copy) NSString *orderType;
@property(nonatomic,copy) NSString *policyType;
@property(nonatomic,copy) NSString *hasPolicy;

/*
 
 private Long userId;
 private String userName;
 private Long price; //续费费用 会员卡费用 单位元 :100
 private String productSkuCode;//sku编码 产品编码 续费产品:CARD0000002，体验会员升级产品CARD0000003
 
 private Integer orderType; //4升级会员卡 ，5续费续保
 private String policyType;//保险类型 1 阳光 2人寿
 private Boolean hasPolicy;//是否买保险  1 0
 */

@end
