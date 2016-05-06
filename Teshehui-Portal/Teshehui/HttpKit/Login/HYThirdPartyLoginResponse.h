//
//  HYThirdPartyLoginResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYUserInfo.h"
#import "HYThirdpartyUser.h"
#import "HYLoginResult.h"

@interface HYThirdPartyLoginResponse : CQBaseResponse

@property (nonatomic, strong) HYUserInfo *userinfo;
@property (nonatomic, strong) HYThirdpartyUser *thirdpartyUser;
@property (nonatomic, strong) HYLoginResult *loginResult;

@end
