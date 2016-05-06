//
//  HYExuserLoginRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYExuserLoginResponse.h"

@interface HYExuserLoginRequest : CQBaseRequest

@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *checkCode;
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *invitationCode;
@property (nonatomic, strong) NSString *promotersUserId;
@property (nonatomic, strong) NSString *agencyId;
@property (nonatomic, assign) NSInteger loginFlag;  //1登录

@end
