//
//  HYChatManager.m
//  Teshehui
//
//  Created by 成才 向 on 16/4/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYChatManager.h"
#import "EaseMob.h"

@implementation HYChatManager

+ (instancetype)sharedManager
{
    static HYChatManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[HYChatManager alloc] init];
    });
    return _sharedManager;
}

- (void)chatLogin
{
    EaseMob *easemob = [EaseMob sharedInstance];
    if ([easemob.chatManager isLoggedIn]) {
        return;
    }
    BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    NSString *hxusername = nil;
    NSString *hxpassword = nil;
    if (islogin)
    {
        /// 这里使用后台给的环信帐号
        HYUserInfo *userinfo = [HYUserInfo getUserInfo];
        hxusername = userinfo.number;
        hxpassword = [userinfo.number substringFromIndex:userinfo.number.length-6];
    }
    else
    {
        /// 这里使用随机帐号
        hxpassword = @"111111";
        hxusername = [self generateRandomUsername];
        
        [easemob.chatManager asyncRegisterNewAccount:hxpassword
                                            password:hxusername
                                      withCompletion:^(NSString *username, NSString *password, EMError *error) {
            if (!error || error.errorCode == EMErrorServerDuplicatedAccount)
            {
            }
        } onQueue:nil];
    }
    
    [easemob.chatManager asyncLoginWithUsername:hxusername
                                       password:hxpassword];
}

- (void)chatLogout
{
    [[[EaseMob sharedInstance] chatManager] asyncLogoffWithUnbindDeviceToken:NO];
}

/// 直接使用xresuid
- (NSString *)generateRandomUsername
{
    NSString *cache = [[NSUserDefaults standardUserDefaults] objectForKey:kXresUid];
    return cache;
}

+ (HYUserInfo *)getCurUserInfo
{
    return [HYUserInfo getUserInfo];
}

@end
