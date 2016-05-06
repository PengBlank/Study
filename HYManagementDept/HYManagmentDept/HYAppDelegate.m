//
//  HYAppDelegate.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-4.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAppDelegate.h"
#import "HYLoginViewController.h"
#import "PTAppStoreHelper.h"
#import "MobClick.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
//#import "UMSocialTencentWeiboHandler.h"
#import "UMSocialWechatHandler.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocial.h"
#import "HYSplitViewController+UmengShake.h"
#import <AlipaySDK/AlipaySDK.h>

NSString * const ThreePartyPaymentResultNotification = @"AlipayResultNotification";  //登录成功

@implementation HYAppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Initialize the app window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //self.window.rootViewController = self.splitViewController;
    
    //UMENG
    [MobClick startWithAppkey:UMengKey
                 reportPolicy:SENDWIFIONLY
                    channelId:ChannelId];
    
    [UMSocialData setAppKey:UMengKey];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [UMSocialWechatHandler setWXAppId:WXAppId
                            appSecret:WXAppSecret
                                  url:@"http://www.teshehui.com"];
    [WXApi registerApp:WXAppId];
    
    //如果没有QQ则不显示相关分享
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://www.teshehui.com"];
    [UMSocialQQHandler setSupportWebView:NO];
    [UMSocialQQHandler setQQWithAppId:QQAppId
                               appKey:QQAppKey
                                  url:@"http://www.teshehui.com"];
    //初始化QQ的授权，不然会存在临时会话不能返回app的问题
    if ([[TencentOAuth alloc] initWithAppId:QQAppId
                                andDelegate:nil])
    {
        DebugNSLog(@"QQ授权对象初始化失败");
    }
    
    
    
//    //检查更新
//    PTAppStoreHelper* appstoreHelper = [PTAppStoreHelper defaultAppStoreHelper];
//    [appstoreHelper checkForceupdate];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    [self showLogin];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)showLogin
{
    if (!_loginViewController) {
        _loginViewController = [[HYLoginViewController alloc] init];
    }
    self.window.rootViewController = _loginViewController;
    
    [_splitViewController stopShake];
    self.splitViewController = nil;
}

- (void)showContent
{
    if (!_splitViewController) {
        _splitViewController = [[HYSplitViewController alloc] init];
    }
    self.window.rootViewController = _splitViewController;
    
    self.loginViewController = nil;
}

- (void)handleOtherLogined
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户未登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.delegate = self;
    alert.tag = 1002;
    [alert show];
}

- (void)handleNotPromoters
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经没有权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.delegate = self;
    alert.tag = 1003;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1002 ||
        alertView.tag == 1003)
    {
        [self showLogin];
    }
}

#pragma mark - URL


//独立客户端回调函数
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.description hasPrefix:@"TshManagementDept"])
    {
        [self parse:url application:application];
        return YES;
    }
    else if  ([url.description hasPrefix:@"wx4a41efaa968348df://pay"])  // weixin pay
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    else
    {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"])
    {
        [self parse:url application:application];
        return YES;
    }
    else if ([url.description hasPrefix:@"TshManagementDept"])
    {
        [self parse:url application:application];
        return YES;
    }
    else if  ([url.description hasPrefix:@"wx4a41efaa968348df://pay"])  // weixin pay
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    else
    {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
}

//阿里支付
- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                              standbyCallback:^(NSDictionary *resultDic) {
                                                  DebugNSLog(@"alipay %@", resultDic);
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:ThreePartyPaymentResultNotification
                                                                                                      object:resultDic];
                                              }];
}

#pragma mark - WXApiDelegate
-(void) onReq:(BaseReq*)req
{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ThreePartyPaymentResultNotification
                                                        object:resp];
}

#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (_splitViewController) {
        [_splitViewController stopShake];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_splitViewController) {
        [_splitViewController umengShake];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
