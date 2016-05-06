//
//  HYUserService.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYThirdPartyLoginController.h"
#import "HYUserInfo.h"
#import "HYUserUpgradeResponse.h"

@interface HYUserService : NSObject

- (void)cancel;

/**
 *  检验手机号是否已被注册
 *  @result registered为yes时表演明已注册
 *  @result err返回错误信息
 */
- (void)checkUserIsRegisterd:(NSString *)phone
                    callback:(void (^)(BOOL registered, NSString *err))callback;

/**
 *  获取体验会员注册验证码
 *  @result succ表示服务调用是否成功
 */
- (void)getExuserCodeWithPhone:(NSString *)phone callback:(void (^)(BOOL succ, NSString *err))callback;

/**
 *  第三方登陆
 *  @param token
 *  @param openid
 *  @param typecode
 *  @result result为0时登陆成功，为1时失败，为-1时表明需要绑定手号
 */
- (void)thirdpartyLogin:(NSString *)token
                 openid:(NSString *)openid
                   type:(NSString *)typeCode
               callback:(void (^)(NSInteger result, HYUserInfo *user, NSString *err))callback;

/**
 *  用户登陆、体验用户注册
 *  @param phone
 *  @param code
 *  @param invitation
 *  @param flag 为1时为注册，0时为登录
 *  @result
 */
- (void)exuserLoginWithPhone:(NSString *)phone
                   checkCode:(NSString *)code
              invitationCode:(NSString *)invitation
                   loginFlag:(NSInteger)flag
                    callback:(void (^)(HYUserInfo *user, NSString *err))callback;

/**
 *  第三方登录获取验证码
 */
- (void)getThirdpartyCheckCodeWithPhone:(NSString *)phone
                               callback:(void (^)(BOOL succ, NSString *err))callback;

/**
 *  第三方登录注册
 */
- (void)thirdPartyRegisterWithPhone:(NSString *)phone
                          checkCode:(NSString *)code
                         inviteCode:(NSString *)code
                              token:(NSString *)token
                             openid:(NSString *)openid
                               type:(NSString *)typeCode
                           callback:(void (^)(HYUserInfo *user, NSString *err))callback;

- (void)updateLoginStatusWithUserInfo:(HYUserInfo *)userinfo;


/**
 *  @brief 升级购卡
 *
 *  @param buy        是否购买保险，如果不买，后面参数可以不用传
 *  @param isContinue 是否是续费
 *  @param type       保险类型code
 *  @param realName   真实姓名
 *  @param idNum      证件号
 *  @param idCode     证件类型code
 *  @param sex        性别 0男1女
 *  @param birthDay   生日
 *  @param mobile     电话号码
 *  @param callback
 */
- (void)upgradeWithBuyPolicy:(BOOL)buy
                  isContinue:(BOOL)isContinue
                  policyType:(NSString *)type
                    realName:(NSString *)realName
                       idNum:(NSString *)idNum
                      idCode:(NSString *)idCode
                         sex:(NSInteger)sex
                    birthDay:(NSString *)birthDay
                      mobile:(NSString *)mobile
                    callback:(void (^)(HYUserUpgradeResponse *repsonse))callback;

/**
 *  @brief 升级不需保险
 *
 *  @param callback 
 */
- (void)upgradeWithNoPolicy:(void (^)(HYUserUpgradeResponse *response))callback;

/**
 *  @brief 获取可用保险类型
 *
 *  @param requestType 请求类型 1激活 2升级 3购卡 4续费 0全部
 *  @param callback
 */
- (void)getPolicyTypesWithRequestType:(NSInteger)requestType callback:(void (^)(NSString *err, NSArray *types))callback;


@end
