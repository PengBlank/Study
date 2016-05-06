//
//  HYThirdPartyRegisterRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYThirdPartyRegisterResponse.h"

@interface HYThirdPartyRegisterRequest : CQBaseRequest

@property (nonatomic, strong) NSString *thirdpartyType;
@property (nonatomic, strong) NSString *thirdpartyToken;
@property (nonatomic, strong) NSString *thirdpartyOpenid;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *checkCode;
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *invitationCode;
@property (nonatomic, strong) NSString *promotersUserId;
@property (nonatomic, strong) NSString *agencyId;

@end
