//
//  HYOnlineBuycardReq.h
//  Teshehui
//
//  Created by HYZB on 14/11/4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYOnlineBuyCardResp.h"

@interface HYOnlineBuycardReq : CQBaseRequest

@property (nonatomic, copy) NSString *cardPrice;
@property (nonatomic, copy) NSString *productSkuCode;
@property (nonatomic, copy) NSString *birthday; //生日，格式yyyy-MM-dd-->
@property (nonatomic, copy) NSString *hasPolicy;
@property (nonatomic, copy) NSString *idCardNum;
@property (nonatomic, copy) NSString *idCardType; //证件类型，01：身份证 02：护照 03：军人证 05：驾驶证 06：港澳回乡证或台胞证 99：其他。-->
@property (nonatomic, copy) NSString *invitationCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *policyType;
@property (nonatomic, copy) NSString *sex; //性别，M表示男，F表示女-->

@end


/*
 private Long cardPrice; // 卡价格  100元
 private String productSkuCode;// 产品编码sku编码CARD0000001
 private String birthday;// "1988-02-01 00:00:01",生日
 private Boolen hasPolicy;// 是否买保险,1买,0不买
 private String idCardNum;// 证件号码
 private String idCardType;// 证件类型
 private String invitationCode;// 邀请码
 private String name;// 保险真实姓名
 private String phone;// 手机号
 private String policyType;// 保险类型 1 阳光 2 人寿
 private String sex;// 性别
*/