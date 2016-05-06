//
//  CQLgoinRequest.h
//  Teshehui
//
//  Created by ChengQian on 13-11-16.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

/*
 登录
*/
#import "CQBaseRequest.h"

@interface HYLoginRequest : CQBaseRequest

@property (nonatomic, copy) NSString *password;  //登录帐号：可以为卡号、帐号、手机号、身份号及姓名。
@property (nonatomic, copy) NSString *loginName;  //登录密码。
@property (nonatomic, copy) NSString *checkCode;

@end
