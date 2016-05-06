//
//  HYChatManager.h
//  Teshehui
//
//  Created by 成才 向 on 16/4/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"
#import "ChatViewController.h"
#import "HYUserInfo.h"
#import "LocalDefine.h"

/**
 *  @brief 环信客服管理对象
 */
@interface HYChatManager : NSObject

+ (instancetype)sharedManager;

/**
 *  登陆管理
 *  如果已登陆环信，那么不作处理。（注意如果从未登陆转为登陆态时，需要调用logOut，否则还是之前的环信帐号）
 *  如果帐号已登陆，则使用后台提供环信帐号
 *  如果帐号未登陆，注册一个随机的帐号，这个帐号生成后，需要进行缓存
 */
- (void)chatLogin;
- (void)chatLogout;

+ (HYUserInfo *)getCurUserInfo;

@end
