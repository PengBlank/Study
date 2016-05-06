//
//  CQAppDelegate.m
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYAppDelegate.h"
//#import "HYLoginV2ViewController.h"
#import "HYLoginViewController.h"
#import "HYNavigationController.h"
#import "HYGuideViewController.h"
#import "HYMallHomeViewController.h"
#import "HYUpdateToOfficialUserViewController.h"

#import "DataVerifier.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "MobClick.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import <TencentOpenAPI/QQApiInterface.h> 
#import <TencentOpenAPI/TencentOAuth.h>
#import <AlipaySDK/AlipaySDK.h>

//#import "EPGLTransitionView.h"
//#import "DemoTransition.h"
#import "PTAppStoreHelper.h"
#import "HYBusinessCardInfo.h"
#import "HYUserInfo.h"
#import "HYShoppingCarView.h"

#import "BPush.h"

#import "HYLocationManager.h"
#import "HYHotelCityInfo.h"
#import "NSURL+HYURL.h"

#import "HYCheckReviewStatusReq.h"
#import "HYReportPushChannelIdReq.h"
#import "PTHttpManager.h"
#import "SDImageCache.h"
//#import "WSPX.h"

#import "HYUpgradeAlertView.h"
#import "METoast.h"
#import "HYPhoneChargeStore.h"

#import "HYAnalyticsManager.h"
#import "HYShareGetPointView.h"

/// 环信
#import "HYChatManager.h"
#import "EMCDDeviceManager.h"

#import "HYScannerViewController.h"
#import "HYMineCardViewController.h"
#import "HYShareGetPointViewController.h"
#import "HYMineInfoViewController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

NSString * const LoginStatusChangeNotification = @"LoginSuccNotification";  //登录成功
NSString * const ThreePartyPaymentResultNotification = @"AlipayResultNotification";  //登录成功
NSString * const ShowMoreTypeViewNotification = @"ShowMoreTypeViewNotification";  //显示更多功能模块的通知
NSString * const WeixinLoginNotification = @"WeixinLoginNotification";

@interface HYAppDelegate ()
<
WXApiDelegate,
BMKGeneralDelegate,
IChatManagerDelegate
>
{
    BOOL _isFrom3DTouch;
    void (^_ThreeDTouchBlock)(void);
}

@property (strong, nonatomic) HYTabbarViewController *baseContentView;
@property (strong, nonatomic) HYNavigationController *baseLoginView;
@property (strong, nonatomic) HYNavigationController *upgradeView;
@property (strong, nonatomic) NSDictionary *threeDTouchDicts;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation HYAppDelegate

+ (void)initialize
{
    if ([self class] == [HYAppDelegate class])
    {
		NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
									   @"深圳", kCurrentCity,
                                       nil];
        /**
         *  如果是企业版发布，则默认为审核通过
         */
#ifdef ADHOC
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:kIsReviewed];
#endif
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    }
}

- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

//3D Touch
- (void)application:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void(^)(BOOL succeeded))completionHandler
{
    //判断先前我们设置的唯一标识
    _isFrom3DTouch = YES;
    
    if (_threeDTouchDicts.count > 0)
    {
        if ([_threeDTouchDicts.allKeys containsObject:shortcutItem.type])
        {
            _ThreeDTouchBlock = _threeDTouchDicts[shortcutItem.type];
            _ThreeDTouchBlock();
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //CDN
//    [WSPX start];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self chooseRootController];
    
    /// toast
    //  在中间显示，免得
    METoastAttribute *attr = [METoast toastAttribute];
    attr.location = METoastLocationMiddle;
    [METoast setToastAttribute:attr];
    
    /**
     *  监听网络状态
     */
    [self performSelector:@selector(getNetWork)
               withObject:nil
               afterDelay:1.0f];
    
    _showRemoteLoginAlert = NO;
    
    _mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:BDMapAccessToken generalDelegate:self];
	if (!ret)
    {
		DebugNSLog(@"manager start failed!");
	}

    [UMSocialData setAppKey:uMengAppKey];
    [UMSocialData openLog:NO];
    
    [MobClick startWithAppkey:uMengAppKey
                 reportPolicy:BATCH
                    channelId:kChannelId];
     NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [UMSocialWechatHandler setWXAppId:WXAppId
                            appSecret:WXAppSecret
                                  url:@"http://www.teshehui.com"];
    
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
    
    [WXApi registerApp:WXAppId];
    
    //复制酒店城市列表
    [HYHotelCityInfo registerDefaultCitys];
    
    //检查更新
    PTAppStoreHelper* appstoreHelper = [PTAppStoreHelper defaultAppStoreHelper];
    [appstoreHelper checkForceupdate];
    
    //百度云推送
    [self registerRemoteNotification];

    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions
                    apiKey:BPushAPIKey
                  pushMode:BPushModeProduction
           withFirstAction:nil
          withSecondAction:nil
              withCategory:nil
                   isDebug:NO];
    
    /// 环信集成
    [[EaseMob sharedInstance] registerSDKWithAppKey:kDefaultAppKey
                                       apnsCertName:kApnsCertName];
     [[EaseMob sharedInstance] application:application
             didFinishLaunchingWithOptions:launchOptions];
    
    //添加环信消息的监听
    [[[EaseMob sharedInstance] chatManager] addDelegate:self
                                          delegateQueue:nil];
    //检查审核状态
    [self checkReviewStatus];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo)
    {
        [self handleRemoteNotifcation:userInfo];
    }
    
    //每次启动应用就更新地理位置信息
    [self updateLocationinfoWithOpenType:1];
    
    //init 3d touch blocks
    _threeDTouchDicts = [self setup3DTouchBlocks];
    
    
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kShakeSignInSwitchStatus] == nil)
    {
        if (localNotifications.count == 0)
        {
            [self registerLocalNotification];
        }
        else
        {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [self registerLocalNotification];
        }
    }
    
    // App 是用户点击本地推送消息启动
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey])
    {
        for (UILocalNotification *notification in localNotifications)
        {
            [self handleLocalNotifcation:notification];
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [WSPX activate];
    //每次启动应用就更新地理位置信息
    [self updateLocationinfoWithOpenType:2];
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setApplicationIconBadgeNumber:0];
    
    [UMSocialSnsService  applicationDidBecomeActive];
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"applicationDidReceiveMemoryWarning");
    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:application];
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:application];
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:application];
}

 - (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DebugNSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken:deviceToken];
    
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        DebugNSLog(@"result %@", result);
        NSString *userid = [result valueForKey:BPushRequestUserIdKey];
        //        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        
        NSString *channelid = [result valueForKey:BPushRequestChannelIdKey];
        [self reportPushChannelId:channelid userId:userid];
    }];
    
    [[EaseMob sharedInstance] application:application
didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    DebugNSLog(@"Register device token: %@", deviceToken);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self handleRemoteNotifcation:userInfo];
}

//独立客户端回调函数
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    DebugNSLog(@"urlhost == %@",url.host);
    
    if ([url.host isEqualToString:@"platformId=wechat"]) { //增加一个友盟微信分享的回调判断。2015-12-04日特友增加。
        [HYLoginViewController wxCancel];
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    
    
    if ([url.host isEqualToString:@"safepay"])
    {
        [self parse:url application:application];
        return YES;
    }
    else if  ([url.description hasPrefix:@"wx4a41efaa968348df://"])  // weixin pay
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.description hasPrefix:@"tencent101033503://"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if  ([url.description hasPrefix:@"tshappioswebtest://"])  // 红包
    {
        return [self handleOpenAppWithUrl:url];
    }
    else
    {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if ([url.host isEqualToString:@"safepay"])
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


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState == UIApplicationStateInactive)
    {
        [self handleLocalNotifcation:notification];
    }
}

#pragma mark - public methods
- (void)hiddenTabbar
{
    HYTabbarViewController *vc = (HYTabbarViewController *)self.window.rootViewController;
    if ([vc isKindOfClass:[HYTabbarViewController class]])
    {
        [vc setTabbarShow:NO];
    }
}

- (void)loadContentView:(BOOL)needUpdate
{
    //加载启动动画
    //        [self showStarAnimation];
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [_baseLoginView dismissViewControllerAnimated:NO
                                       completion:nil];
    _baseLoginView = nil;
    
    _baseContentView = [[HYTabbarViewController alloc] init];
    self.window.rootViewController = _baseContentView;
}

- (void)loadLoginView
{
    HYLoginViewController *vc = [[HYLoginViewController alloc] init];
    _baseLoginView = [[HYNavigationController alloc]initWithRootViewController:vc];
    [self.window.rootViewController presentViewController:_baseLoginView
                                                 animated:YES
                                               completion:nil];
}

- (void)showUpGrade
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您还不是正式会员哦，升级正式会员享受无限优惠!"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"done", nil), nil];
    alertView.tag = 918;
    [alertView show];
}

- (void)loginOther:(BOOL)other
{
    if (!_showRemoteLoginAlert)
    {
        _showRemoteLoginAlert = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您的账号在其它地方登录，如非本人操作，建议修改密码。"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"done", nil), nil];
        [alertView show];
    }
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
#if !TARGET_IPHONE_SIMULATOR
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity)
    {
        [self showNotificationWithMessage:message];
    }
    else
    {
        [self playSoundAndVibration];
    }
#endif
}

- (void)playSoundAndVibration
{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.vidio", @"Vidio");
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - BPushDelegate
/*
 * 百度云推送
 */
- (void)onMethod:(NSString*)method response:(NSDictionary*)data {
     DebugNSLog(@"On method:%@", method);
     DebugNSLog(@"data:%@", [data description]);
    
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethodBind isEqualToString:method])
    {
//        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
//        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        [self reportPushChannelId:channelid userId:userid];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            [self.baseContentView handleRemoteNotifionInfo];
        }
    }
    else if (alertView.tag == 918)
    {
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            HYUpgradeAlertView *alert = [[HYUpgradeAlertView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
            [alert showWithAnimation:YES];
            alert.controllerHandler = ^(HYUpdateToOfficialUserViewController *update, HYPaymentViewController *payment)
            {
                if (update)
                {
                    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:update];
                    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
                }
                else if (payment)
                {
                    payment.navbarTheme = HYNavigationBarThemeRed;
                    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:payment];
                    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
                    payment.paymentCallback = ^(HYPaymentViewController *payvc, id data)
                    {
                        [payvc.navigationController dismissViewControllerAnimated:YES completion:^{
                            HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
                            vc.cashCard = @"1000";
                            [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
                        }];
                    };
                }
            };
        }
    }
    else
    {
        _showRemoteLoginAlert = NO;
        
        [self logoutFinished];
        
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            [self loadLoginView];
        }
    }
}

#pragma mark private methods
/** 根据本地通知跳转 */
- (void)handleLocalNotifcation:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        NSString *info = userInfo[@"shakeSignInWakeup"];
        if (info != nil)
        {
            [self.baseContentView handleLocalNotifcation];
        }
    }
}

/** 设置本地通知 */
- (void)registerLocalNotification
{
    NSString *fireTimerStr = @"10:30";
    [[NSUserDefaults standardUserDefaults] setObject:fireTimerStr
                                              forKey:kShakeSignInWakeupTime];
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:kShakeSignInSwitchStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(@"HH:mm")];
    NSDate *fireTime = [formatter dateFromString:fireTimerStr];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.fireDate = fireTime;
    localNotification.repeatInterval = NSCalendarUnitDay;
    localNotification.alertBody = @"快来摇一摇签到啊，持之以恒，N多现金劵就是你的。";
    localNotification.soundName= UILocalNotificationDefaultSoundName;
    
    // 设定通知的userInfo，用来标识该通知
    NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
    aUserInfo[@"shakeSignInWakeup"] = @"shakeSignInWakeup";
    localNotification.userInfo = aUserInfo;

    //     ios8后，需要添加这个注册，才能得到授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2)
    {
        localNotification.alertTitle = @"特奢汇签到提醒";
    }
    
    // 将通知添加到系统中
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


- (void)handleRemoteNotifcation:(NSDictionary *)userInfo
{
    DebugNSLog(@"Receive Notify: %@", userInfo);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
    
    //缓存起来
    [[NSUserDefaults standardUserDefaults] setObject:userInfo
                                              forKey:kRemoteNotificationUserInfo];
    
    NSString *title = [userInfo objectForKey:@"title"];
    NSString *desc = [userInfo objectForKey:@"description"];
    //提示框，用户点击确定的时候就打开跳转
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:desc
                                                       delegate:self
                                              cancelButtonTitle:@"忽略"
                                              otherButtonTitles:@"去逛逛", nil];
    alertView.tag = 10;
    [alertView show];
}

- (void)reportPushChannelId:(NSString *)channelId userId:(NSString *)userId
{
    HYUserInfo *user = [HYUserInfo getUserInfo];
    if (user.userId && channelId)
    {
        HYReportPushChannelIdReq *req = [[HYReportPushChannelIdReq alloc] init];
        req.channelid = channelId;
        req.user_id = user.userId;
        req.baidu_user_id = userId;
        
        [req sendReuqest:^(id result, NSError *error) {
        }];
    }
}

- (NSDictionary *)setup3DTouchBlocks
{
    WS(weakSelf);
    //init 3DTouch block,please set it as the plist sequence
    void (^swipeBlock)(void) = ^{
        if (self.baseContentView.viewControllers.count > 0)
        {
            [weakSelf.baseContentView setCurrentSelectIndex:0];
            UINavigationController *nav = weakSelf.baseContentView.viewControllers[0];
            [nav popToRootViewControllerAnimated:NO];
            HYScannerViewController *vc = [[HYScannerViewController alloc] init];
            vc.baseViewController = weakSelf.baseContentView;
            [nav pushViewController:vc animated:NO];
//            UIViewController *vc = nav.topViewController;
            if ([vc respondsToSelector:@selector(scannerBtnAction)])
            {
                [vc performSelector:@selector(scannerBtnAction)];
            }
        }
    };
    
    void (^checkoutBlock)(void) = ^{
        if (self.baseContentView.viewControllers.count > 0)
        {
            [weakSelf.baseContentView setCurrentSelectIndex:0];
            UINavigationController *nav = weakSelf.baseContentView.viewControllers[0];
            [nav popToRootViewControllerAnimated:NO];
//            UIViewController *vc = nav.topViewController;
            HYScannerViewController *vc = [[HYScannerViewController alloc] init];
            vc.baseViewController = weakSelf.baseContentView;
            [nav pushViewController:vc animated:NO];
            if ([vc respondsToSelector:@selector(quickBuyBtnAction)])
            {
                [vc performSelector:@selector(quickBuyBtnAction)];
            }
        }
    };
    
    void (^myIdCardBlock)(void) = ^{
        if (self.baseContentView.viewControllers.count > 0)
        {
            [weakSelf.baseContentView setCurrentSelectIndex:0];
            UINavigationController *nav = weakSelf.baseContentView.viewControllers[0];
            [nav popToRootViewControllerAnimated:NO];
            HYMineCardViewController *vc = [[HYMineCardViewController alloc] init];
            vc.baseViewController = weakSelf.baseContentView;
            [nav pushViewController:vc animated:NO];
            [vc.baseViewController setTabbarShow:NO];
        }
    };
    
    void (^shareToEarnBlock)(void) = ^{
        if (self.baseContentView.viewControllers.count > 0)
        {
            UINavigationController *nav = weakSelf.baseContentView.viewControllers[3];
            [nav popToRootViewControllerAnimated:YES];
            [weakSelf.baseContentView setCurrentSelectIndex:3];
            
            HYMineInfoViewController *vc = (HYMineInfoViewController *)nav.topViewController;
            [vc performSelector:@selector(viewDidAppear:) withObject:@NO];
            HYShareGetPointView *share = [HYShareGetPointView sharedView];
            if (share.didCheck)
            {
                share.didCheck();
            }
            [vc.baseViewController setTabbarShow:NO];
//            if ([vc isViewLoaded])
//            {
//           
//            }
        }
    };
    
    NSDictionary *blocksDict = @{@"UITouchText.swipe" :swipeBlock,
                                 @"UITouchText.checkout" :checkoutBlock,
                                 @"UITouchText.myIdCard" :myIdCardBlock,
                                 @"UITouchText.shareToEarn" :shareToEarnBlock
                                 };
    return blocksDict;
}

#pragma mark - 审核检查
/**
 *  检测是否已通过审核
 *  需首页判断缓存的版本号是否存在并与当前版本号进行对比.
 *  如果缓存版本号不存在, 或者缓存版本号低于当前版本号, 则需要调用接口进行判断
 *  接口返回后缓存接口结果
 */
- (void)checkReviewStatus
{
    NSString *cacheVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"BundleShortVersionString"];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    if (!cacheVersion)
    {
        [[NSUserDefaults standardUserDefaults] setObject:version
                                                  forKey:@"BundleShortVersionString"];
    }
    //如果并没有该缓存,则必须要进取一次
    BOOL hasReviewKey = ([[NSUserDefaults standardUserDefaults] objectForKey:kIsReviewed] != nil);
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:kIsReviewed];
    if (!cacheVersion || [version compare:cacheVersion] == NSOrderedDescending || !hasReviewKey)
    {
        HYCheckReviewStatusReq *req = [[HYCheckReviewStatusReq alloc] init];
        req.version = version;
        [req sendReuqest:^(id result, NSError *error)
        {
            if (!error)
            {
                HYCheckReviewStatusResp *resp = (HYCheckReviewStatusResp *)result;
                if ([resp.version isEqualToString:version])
                {
                    BOOL isReview = resp.reviewStatus;//1 表示已审核过 0表示其他
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setBool:isReview
                          forKey:kIsReviewed];
                    [def synchronize];
                }
            }
        }];
    }
}

- (BOOL)handleOpenAppWithUrl:(NSURL *)url
{
    NSDictionary *params = [url queryParam];
    NSString *redpacket_id = [params objectForKey:@"id"];
    if (redpacket_id)
    {
       
    }
    return NO;
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

+ (instancetype)sharedDelegate
{
    return (HYAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)chooseRootController
{
    NSString *key = @"Guidance";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    key = [key stringByAppendingString:version];
    
    // 取出是否需要引导页
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *guidance = [defaults objectForKey:key];
    BOOL isGuided = [guidance boolValue];
    
    if (!isGuided)
    {
        // 隐藏状态栏
        [UIApplication sharedApplication].statusBarHidden = YES;
        HYGuideViewController *vc = [[HYGuideViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        
        isGuided = YES;
        guidance = [NSNumber numberWithBool:isGuided];
        
        [defaults setObject:guidance forKey:key];
        [defaults synchronize];
    }
    else
    {
        [self loadContentView:YES];
    }
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
    if ([resp isKindOfClass:[PayResp class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:ThreePartyPaymentResultNotification
                                                            object:resp];
    }
    else if ([resp isKindOfClass:[SendAuthResp class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WeixinLoginNotification
                                                            object:resp];
    }
}

#pragma mark - BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        DebugNSLog(@"联网成功");
    }
    else{
        DebugNSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        DebugNSLog(@"授权成功");
    }
    else {
        DebugNSLog(@"onGetPermissionState %d",iError);
    }
}


#pragma mark - 获取定位信息

- (void)updateLocationinfoWithOpenType:(NSInteger)opentype
{
    [[HYLocationManager sharedManager] clearAddressInfo];
    [[HYLocationManager sharedManager] getCacheAddressInfo:^(HYLocateState state, HYLocateResultInfo *addrInfo) {
        [HYAnalyticsManager sendAppOpenWithOpenType:opentype];
    }];
}

- (void)logoutFinished
{
    //清除用户信息
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setBool:NO forKey:kIsLogin];
    [def setBool:NO
          forKey:kShoppingCarHasNew];
    [def removeObjectForKey:kUserInfo];
    [def setObject:@"深圳" forKey:kCurrentCity];
    [def removeObjectForKey:kLastStartCity];
    [def removeObjectForKey:kLastComeCity];
    [def setObject:@"深圳" forKey:kHotelDefCity];
    [def removeObjectForKey:kUserLocation];
    [def removeObjectForKey:kUserAddress];
    [def removeObjectForKey:kHotelCheckOutDate];
    [def removeObjectForKey:kHotelCheckInDate];
    [def removeObjectForKey:kHotelCityInfoUpdate];
    [def removeObjectForKey:@"kInvoiceTitles"]; //发票抬头
    [def removeObjectForKey:kRemoteNotificationUserInfo];
    [def removeObjectForKey:kToken];
    [def synchronize];
    
    [[HYPhoneChargeStore sharedStore] clearRecords];
    
    //
    [HYBusinessCardInfo cleanCache];
    
    [[HYChatManager sharedManager] chatLogout];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangeNotification
                                                        object:nil];
    
    //取消所有请求
    [[PTHttpManager getInstantane] cancelAll];
    
    //清除http缓存
    [[PTHttpManager getInstantane] cleanCache];
    
    //退出客服
    [[HYChatManager sharedManager] chatLogout];
    
    //清除图片缓存
    [[SDImageCache sharedImageCache] clearMemory];
    if ([[SDImageCache sharedImageCache] getSize] > (1024*1024*50))
    {
        [[SDImageCache sharedImageCache] clearDisk];
    }
}


- (void)getNetWork
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DebugNSLog(FORMAT_Integer, status);
    }];
}

/// 检测是否登录，如果没登录，就弹出登录框，成功后需继续进行之前的动作
- (void)checkLogin:(void (^)(BOOL success))callback
{
    BOOL logined = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (logined) {
        if (callback) {
            callback(YES);
        }
    }
    else
    {
        _loginSuccessCallback = [callback copy];
        [self loadLoginView];
    }
}



@end
