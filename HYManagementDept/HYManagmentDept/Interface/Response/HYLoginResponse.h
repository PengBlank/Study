//
//  HYLoginResponse.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/*
 * 代理运营管理系统用户登录
 */

#import "HYBaseResponse.h"
#import "HYUserInfo.h"

@interface HYLoginResponse : HYBaseResponse

@property (nonatomic, readonly, strong) HYUserInfo *userInfo;  //用户信息

@end
