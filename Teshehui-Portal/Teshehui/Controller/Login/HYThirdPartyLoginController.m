//
//  HYThirdPartyLoginController.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYThirdPartyLoginController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "JSONKit_HY.h"
#import "METoast.h"

NSString *const HYThirdPartyQQ = @"01";
NSString *const HYThirdPartyWeixin = @"02";

UIKIT_EXTERN NSString * const WeixinLoginNotification;

@implementation HYThirdPartyLoginController

- (void)loginWithTencent
{
    NSArray *_permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    
    if (!_tencentAuth)
    {
        _tencentAuth = [[TencentOAuth alloc] initWithAppId:QQAppId andDelegate:self];
        if (!_tencentAuth)
        {
            //
        }
    }
    [_tencentAuth authorize:_permissions inSafari:NO];
}

- (void)loginWithWeixin
{
    SendAuthReq* req = [[SendAuthReq alloc ] init];
    req.scope = @"snsapi_base,snsapi_userinfo";
    req.state = @"123" ;
    [WXApi sendReq:req];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxResponse:) name:WeixinLoginNotification object:nil];
}

- (void)wxResponse:(NSNotification *)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SendAuthResp *resp = notify.object;
    if (resp.errCode == 0)
    {
        [METoast toastWithMessage:@"授权成功"];
        
        NSString *accessTokenURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                                    WXAppId,
                                    WXAppSecret,
                                    resp.code];
        __weak typeof(self) b_self = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            NSString *tokenRes = [NSString stringWithContentsOfURL:[NSURL URLWithString:accessTokenURL] encoding:NSUTF8StringEncoding error:nil];
            NSDictionary *data = [tokenRes objectFromJSONString];
            dispatch_async(dispatch_get_main_queue(), ^
            {
                NSString *token = [data objectForKey:@"access_token"];
                NSString *openid = [data objectForKey:@"openid"];
                if (b_self.delegate)
                {
                    [b_self.delegate didGetThirdLoginToken:token
                                                    openId:openid
                                                 loginType:HYThirdPartyWeixin];
                }
            });
        });
    }
    else if (resp.errCode == -4)
    {
        
    }
    else if (resp.errCode == -2)
    {
        
    }
    
    
}

#pragma mark - QQ回调

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    [METoast toastWithMessage:@"授权成功"];
    if (_delegate)
    {
        [_delegate didGetThirdLoginToken:_tencentAuth.accessToken
                                  openId:_tencentAuth.openId
                               loginType:HYThirdPartyQQ];
        
    }
//    if (_tencentAuth.accessToken && _tencentAuth.accessToken.length != 0)
//    {
//        [_tencentAuth getUserInfo];
//    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [METoast toastWithMessage:@"授权取消"];
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(thirdLoginFailWithMessage:loginType:)])
        {
            [_delegate thirdLoginFailWithMessage:nil loginType:HYThirdPartyQQ];
        }
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    
}

/**
 * 退出登录的回调
 */
- (void)tencentDidLogout
{
    
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response
{
    NSString *name =  [response.jsonResponse objectForKey:@"nickname"];
    DebugNSLog(@"%@", name);
}

@end
