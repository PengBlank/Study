//
//  HYUserService.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUserService.h"
#import "HYExuserCheckRequest.h"
#import "HYExuserGetCodeRequest.h"
#import "HYExuserLoginRequest.h"
#import "HYThirdPartyLoginRequest.h"
#import "HYThirdPartyRegisterRequest.h"
#import "HYThirdpartyValidateRequest.h"
#import "HYAppDelegate.h"
#import "HYUserUpgradeRequest.h"
#import "HYGetPolicyListRequest.h"
#import "HYGetPolicyListResponse.h"

extern NSString *const LoginStatusChangeNotification;

@interface HYUserService ()
{
    HYThirdPartyLoginRequest *_loginRequest;
    
    //体验用户登陆
    HYExuserCheckRequest *_checkRequest;
    HYExuserGetCodeRequest *_getCodeRequest;
    HYExuserLoginRequest *_exloginRequest;
    
    HYUserUpgradeRequest *_upgradeRequest;
    
    HYGetPolicyListRequest *_getPolicyTypeRequest;
}

@property (nonatomic, strong) HYThirdpartyValidateRequest *validateRequest;
@property (nonatomic, strong) HYThirdPartyRegisterRequest *registerRequest;

@end

@implementation HYUserService

- (void)cancel
{
    [_loginRequest cancel];
    [_getCodeRequest cancel];
    [_exloginRequest cancel];
    [_validateRequest cancel];
    [_registerRequest cancel];
    [_upgradeRequest cancel];
    [_getPolicyTypeRequest cancel];
}

/**
 *  检验手机号是否已被注册
 *  @result registered为yes时表演明已注册
 *  @result err返回错误信息
 */
- (void)checkUserIsRegisterd:(NSString *)phone
                    callback:(void (^)(BOOL registered, NSString *err))callback
{
    if (!_checkRequest)
    {
        _checkRequest = [[HYExuserCheckRequest alloc] init];
    }
    [_checkRequest cancel];
    _checkRequest.mobilephone = phone;
    [_checkRequest sendReuqest:^(HYExuserCheckResponse* result, NSError *error)
     {
         if (result.status == 200)
         {
             callback(result.registered, nil);
         }
         else
         {
             callback(NO, error.domain);
         }
     }];
}

/**
 *  获取体验会员注册验证码
 *  @result succ表示服务调用是否成功
 */
- (void)getExuserCodeWithPhone:(NSString *)phone callback:(void (^)(BOOL succ, NSString *err))callback
{
    if (!_getCodeRequest)
    {
        _getCodeRequest = [[HYExuserGetCodeRequest alloc] init];
    }
    _getCodeRequest.mobilephone = phone;
    [_getCodeRequest sendReuqest:^(HYExuserGetCodeResponse* result, NSError *error)
     {
         if (result.status == 200)
         {
             callback(YES, nil);
         }
         else
         {
             callback(NO, error.domain);
         }
     }];
}

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
               callback:(void (^)(NSInteger result, HYUserInfo *user, NSString *err))callback
{
    if (!_loginRequest)
    {
        _loginRequest = [[HYThirdPartyLoginRequest alloc] init];
    }
    _loginRequest.thirdpartyToken = token;
    _loginRequest.thirdpartyOpenid = openid;
    _loginRequest.thirdpartyType = typeCode;
    [HYLoadHubView show];
    [_loginRequest sendReuqest:^(HYThirdPartyLoginResponse* result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (result.code == 100)  //具体消息对应的响应状态码值；当具体错误代码是100（暂定）说明用户未注册，前端可根据需要提示用户注册
         {
             callback(-1, nil, nil);
         }
         else if (result.status == 200)
         {
             callback(0, result.userinfo, nil);
         }
         else
         {
             callback(1, nil, error.domain);
         }
     }];
}

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
                    callback:(void (^)(HYUserInfo *user, NSString *err))callback
{
    if (!_exloginRequest)
    {
        _exloginRequest = [[HYExuserLoginRequest alloc] init];
    }
    _exloginRequest.checkCode = code;
    _exloginRequest.mobilePhone = phone;
    _exloginRequest.invitationCode = invitation;
    _exloginRequest.loginFlag = flag;
    [HYLoadHubView show];
    [_exloginRequest sendReuqest:^(HYExuserLoginResponse* result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (result.status == 200)
         {
             callback(result.userinfo, nil);
         }
         else
         {
             callback(nil, error.domain);
         }
     }];
}

- (void)getThirdpartyCheckCodeWithPhone:(NSString *)phone
                               callback:(void (^)(BOOL succ, NSString *err))callback
{
    if (!_validateRequest)
    {
        _validateRequest = [[HYThirdpartyValidateRequest alloc] init];
    }
    _validateRequest.mobilePhone = phone;
    [HYLoadHubView show];
    [_validateRequest sendReuqest:^(HYThirdPartyRegisterResponse* result, NSError *error)
     {
         callback(result.status == 200, error.domain);
     }];
}

/**
 *  第三方登录注册
 */
- (void)thirdPartyRegisterWithPhone:(NSString *)phone
                          checkCode:(NSString *)code
                         inviteCode:(NSString *)invite
                              token:(NSString *)token
                             openid:(NSString *)openid
                               type:(NSString *)typeCode
                           callback:(void (^)(HYUserInfo *user, NSString *err))callback
{
    if (!_registerRequest)
    {
        _registerRequest = [[HYThirdPartyRegisterRequest alloc] init];
    }
    [_registerRequest cancel];
    _registerRequest.checkCode = code;
    _registerRequest.invitationCode = invite;
    _registerRequest.mobilePhone = phone;
    _registerRequest.invitationCode = invite;
    _registerRequest.thirdpartyToken = token;
    _registerRequest.thirdpartyOpenid = openid;
    _registerRequest.thirdpartyType = typeCode;
    [HYLoadHubView show];
    [_registerRequest sendReuqest:^(HYThirdPartyRegisterResponse* result, NSError *error)
     {
         callback(result.userinfo, error.domain);
     }];
}

- (void)updateLoginStatusWithUserInfo:(HYUserInfo *)userinfo
{
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:kIsLogin];
    [userinfo saveData];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangeNotification object:nil];
    
    HYAppDelegate* appDelegate = (HYAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate loadContentView:YES];
}

- (void)upgradeWithBuyPolicy:(BOOL)buy isContinue:(BOOL)isContinue policyType:(NSString *)type realName:(NSString *)realName idNum:(NSString *)idNum idCode:(NSString *)idCode sex:(NSInteger)sex birthDay:(NSString *)birthDay mobile:(NSString *)mobile callback:(void (^)(HYUserUpgradeResponse*))callback
{
    _upgradeRequest = [[HYUserUpgradeRequest alloc] init];
    /*
     用户注册激活接口，升级为正式会员接口请求参数增加：hasPolicy是否买保险0非，1是，policyType保险类型1平安2人寿。
     
     */
    _upgradeRequest.isBuypolicy = buy ? @"1": @"0";
    _upgradeRequest.policyType = type;
    _upgradeRequest.orderType = isContinue ? @"5" : @"4";
    _upgradeRequest.realName = realName;
    _upgradeRequest.certificateNumber = idNum;
    _upgradeRequest.certificateCode = idCode;
    _upgradeRequest.sex = hyGetJavaSexStringFromSex(sex).integerValue;
    _upgradeRequest.mobilephone = mobile;
    _upgradeRequest.birthday = birthDay;
    
    [_upgradeRequest sendReuqest:^(id result, NSError *error)
    {
        HYUserUpgradeResponse *response = nil;
        if ([result isKindOfClass:[HYUserUpgradeResponse class]])
        {
            response = (HYUserUpgradeResponse *)result;
        }
        callback(response);
    }];
}

- (void)upgradeWithNoPolicy:(void (^)(HYUserUpgradeResponse *))callback
{
    HYUserInfo *userinfo = [HYUserInfo getUserInfo];
    [self upgradeWithBuyPolicy:NO
                    isContinue:NO
                    policyType:nil
                      realName:userinfo.realName
                         idNum:userinfo.certificateNumber
                        idCode:userinfo.certificateCode
                           sex:userinfo.localSex
                      birthDay:userinfo.birthday
                        mobile:userinfo.mobilePhone
                      callback:callback];
}

- (void)getPolicyTypesWithRequestType:(NSInteger)requestType callback:(void (^)(NSString *, NSArray *))callback
{
    if (!_getPolicyTypeRequest)
    {
        _getPolicyTypeRequest = [[HYGetPolicyListRequest alloc] init];
    }
    [_getPolicyTypeRequest cancel];
    /*
     1：激活会员卡
     
     2：虚拟会员升级
     
     3：在线购卡
     
     4：续费
     
     注：不传则返回全部
     */
    if (requestType != 0) {
        _getPolicyTypeRequest.type = [NSString stringWithFormat:@"%ld", requestType];
    }
    
    
    [_getPolicyTypeRequest sendReuqest:^(HYGetPolicyListResponse *result, NSError *error)
    {
        
        [HYLoadHubView dismiss];
        if (result.status == 200)
        {
            callback(nil, result.dataList);
        }
        else
        {
            callback(error.domain, nil);
        }
    }];
}

@end
