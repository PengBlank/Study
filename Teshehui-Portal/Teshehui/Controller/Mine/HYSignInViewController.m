//
//  HYSignInViewController.m
//  Teshehui
//
//  Created by HYZB on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYSignInViewController.h"
#import "HYSignInBannerView.h"
#import "HYSignInDayView.h"
#import "HYSignInRuleView.h"
#import "HYSignInResponse.h"
#import "HYSignInRequest.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "METoast.h"
#import "HYSignInWakeupDateView.h"
#import "HYAppDelegate.h"
#import "HYPointsViewController.h"


@interface HYSignInViewController ()

@property (nonatomic, strong) UIScrollView *sv;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *dayView;
@property (nonatomic, strong) UIView *finallyDayView;
@property (nonatomic, strong) UIDatePicker *picker;
@property (nonatomic, strong) UILabel *wakeupLab;
@property (nonatomic, copy) NSString *fireTimeStr;
@property (nonatomic, strong) UISwitch *swi;

@property (nonatomic, strong) HYSignInRequest *signInReq;
@property (nonatomic, strong) HYSignInDayView *dayV;
@property (nonatomic, strong) HYSignInBannerView *bannerV;
@property (nonatomic, strong) HYSignInWakeupDateView *wakeupV;

/** 当前连续签到次数 */
@property (nonatomic, copy) NSString *currentSignNum;

@end

@implementation HYSignInViewController

- (void)dealloc
{
    [_signInReq cancel];
    _signInReq = nil;
    
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    self.navBarTitleWidth = 60;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签到";
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 40);
    [btn setTitle:@"我的现金券" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithWhite:0.4f alpha:1.0f] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:frame];
    sv.backgroundColor = [UIColor clearColor];
    _sv = sv;
    [self.view addSubview:sv];
    
    HYSignInBannerView *bannerV = [[HYSignInBannerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 130)];
    [_sv addSubview:bannerV];
    _bannerV = bannerV;
    
    CGFloat btnY = CGRectGetMaxY(bannerV.frame) + 15;
    CGFloat btnW = 140;
    CGFloat btnH = 20;
    
    UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectMake(TFScalePoint(300)-20, btnY-6, 20, 20)];
    swi.frame = CGRectMake(TFScalePoint(300)-swi.frame.size.width, btnY-6, 20, 20);
    _swi = swi;
    [_sv addSubview:swi];
    [swi addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    swi.on = [[NSUserDefaults standardUserDefaults] boolForKey:kShakeSignInSwitchStatus];
    
    UIButton *wakeupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wakeupBtn setFrame:CGRectMake(CGRectGetMinX(swi.frame)-10-btnW, btnY, btnW, btnH)];
    [wakeupBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 60)];
    [wakeupBtn addTarget:self action:@selector(wakeupBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [wakeupBtn setTitle:@"签到提醒" forState:UIControlStateNormal];
    wakeupBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [wakeupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sv addSubview:wakeupBtn];
//    wakeupBtn.backgroundColor = [UIColor redColor];
    UILabel *wakeupLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(wakeupBtn.frame)+75, btnY, 60, 20)];
    _wakeupLab = wakeupLab;
    _fireTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:kShakeSignInWakeupTime];
    wakeupLab.text = [NSString stringWithFormat:@"(%@)", _fireTimeStr];
    // 246 103 102
    wakeupLab.textColor = [UIColor colorWithRed:246/255.0f green:103/255.0f blue:102/255.0f alpha:1.0f];
    [_sv addSubview:wakeupLab];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(wakeupBtn.frame)+20, frame.size.width, 2)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    [_sv addSubview:lineView];
    
    HYSignInDayView *dayV = [[HYSignInDayView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), frame.size.width, 300)];
//    dayV.backgroundColor = [UIColor redColor];
    [_sv addSubview:dayV];
    _dayV = dayV;
    
    HYSignInRuleView *ruleV = [[HYSignInRuleView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dayV.frame), frame.size.width, 300)];
    [_sv addSubview:ruleV];
    
    _sv.contentSize = CGSizeMake(frame.size.width, CGRectGetMaxY(ruleV.frame));
    
    [self loadData];
}

#pragma mark - privateMethod
- (void)loadData
{
    if (!_signInReq)
    {
        _signInReq = [[HYSignInRequest alloc] init];
    }
    NSString *userId = [HYUserInfo getUserInfo].userId;
    if (userId)
    {
        _signInReq.userId = userId;
    }
    
    WS(weakSelf)
    [HYLoadHubView show];
    [_signInReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        HYSignInResponse *respon = (HYSignInResponse *)result;
        if (respon.status == 200)
        {
            weakSelf.currentSignNum = respon.currentSignNum;
            // 显示出签到天数：number
            NSInteger number = respon.currentSignNum.integerValue % 30;
            NSString *continuousDays = [NSString stringWithFormat:@"%ld", number];
            weakSelf.dayV.currentSignNum = continuousDays;
            weakSelf.bannerV.currentSignNum = [NSString stringWithFormat:@"%ld", number];
        }
        else
        {
            [METoast toastWithMessage:respon.suggestMsg];
        }
    }];
}

- (void)confirmBtnAction:(UIButton *)btn
{
    
    [[NSUserDefaults standardUserDefaults] setObject:_fireTimeStr
                                              forKey:kShakeSignInWakeupTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _wakeupV.hidden = YES;
    
    if (_swi.isOn)
    {
        [self cancelForeLocalNotification];
        [self registerLocalNotification];
    }
}

- (void)pickerAction:(UIDatePicker *)picker
{
    _fireTimeStr = [_wakeupV.formatter stringFromDate:picker.date];
    _wakeupLab.text = [NSString stringWithFormat:@"(%@)", _fireTimeStr];
}

/** 设置本地通知 */
- (void)registerLocalNotification
{
    NSString *fireTimerStr = [[NSUserDefaults standardUserDefaults] objectForKey:kShakeSignInWakeupTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(@"HH:mm")];
    NSDate *fireTime = [formatter dateFromString:fireTimerStr];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.fireDate = fireTime;
    localNotification.repeatInterval = NSCalendarUnitDay;
    localNotification.alertBody = @"快来摇一摇签到啊，持之以恒，N多现金劵就是你的。";
    localNotification.soundName= UILocalNotificationDefaultSoundName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2)
    {
        localNotification.alertTitle = @"特奢汇签到提醒";
    }
    // 设定通知的userInfo，用来标识该通知
    NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
    aUserInfo[@"shakeSignInWakeup"] = @"shakeSignInWakeup";
    localNotification.userInfo = aUserInfo;
    // 将通知添加到系统中
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

/** 取消旧的本地通知 */
- (void)cancelForeLocalNotification
{
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    if (localNotifications.count > 0)
    {
        for (UILocalNotification *notification in localNotifications)
        {
            NSDictionary *userInfo = notification.userInfo;
            if (userInfo)
            {
                NSString *info = userInfo[@"shakeSignInWakeup"];
                
                // 如果找到需要取消的通知，则取消
                if (info != nil)
                {
                    [[UIApplication sharedApplication] cancelLocalNotification:notification];
                }
            }
        }
    }
}

- (void)switchAction:(UISwitch *)sender
{
    if (sender.isOn)
    {
        [self cancelForeLocalNotification];
        [self registerLocalNotification];
    }
    else
    {
        [self cancelForeLocalNotification];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:kShakeSignInSwitchStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)wakeupBtnAction:(UIButton *)btn
{
    if (!_wakeupV)
    {
        HYSignInWakeupDateView *wakeupV = [[HYSignInWakeupDateView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-220, self.view.frame.size.width, 240)];
        [self.view addSubview:wakeupV];
        _wakeupV = wakeupV;
        [wakeupV.ConfirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [wakeupV.picker addTarget:self action:@selector(pickerAction:) forControlEvents:UIControlEventValueChanged];
    }

    NSDate *fireTime = [_wakeupV.formatter dateFromString:_fireTimeStr];
    _wakeupV.picker.date = fireTime;

    _wakeupV.hidden = NO;
}

- (void)rightBtnAction:(UIButton *)btn
{
    HYPointsViewController *point = [[HYPointsViewController alloc] init];
    [self.navigationController pushViewController:point animated:YES];
}

@end
